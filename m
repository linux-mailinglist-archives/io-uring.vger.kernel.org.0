Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA30B4F639F
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 17:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbiDFPmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 11:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbiDFPlj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 11:41:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8E73ED980
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 05:58:30 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i11so1847452plg.12
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 05:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5E233did5iE2r4VmvrIREFy4zTvvx8mra5BGEgNhjbw=;
        b=yBnajfM+hkiNode+CXJl2a4SrIXZetWRochUZqaus2qglu4Xu7fjbwz42BlaY6XB8f
         oXBB+T7+8PlqWhUYp8w0MAGGez5oK+Z1jHhCHTVt8nKtwvl/C6GHuMTOOpNKyd8cotzc
         fjnN8XLw8Gj3wpxG3IgAzvW6hobKiOXFG8fB59lGC1x5sKAFyubAs4qeeFqNbJDYiY47
         Qv3ArabtxjCD4gEbbEZRXDF+Uh3PQh159j/OIgswXJRXAFPTqRARSnwjID4pBv9dNQoT
         bDWj08O60G4RX21K76IRAmB33gMZfnSPM/YFnkhQK8sb3r0fYCxfewuSXZLcLsz2BuPl
         3OYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5E233did5iE2r4VmvrIREFy4zTvvx8mra5BGEgNhjbw=;
        b=roL0499qDMwZfpQnoMzomHr/EYYUXKWeeMgJWdFnkCKTS7JLnBPQL8VW8OSRg1NWI+
         Oy3sN5TNJqvCHbuLHdl2kn3zqG9ZNo6WNc9JoXVrpultevuLMMEB2xY4EH8TlhJvX+M8
         j8oKiBmZagTHH+D0cOLztqbTth7Lhyosl1NjhfH2eO/HQWG6raNUwbgE+3coWLFLpELC
         hOxm895NHqtzIz9bLnFlpIsxzEWJdF36fdsYvJIr9h/gFhu7+XO4pwe2dUZqm4iOKBNN
         U/MTfw0ezNrRuczNLzELYUWsYhKh8RhCOnuRL2OHPCuu/zoNageJBUQCkgtfvHiG8Doc
         tcCw==
X-Gm-Message-State: AOAM53033W5OkjdUpxV97LQTEYlNZY6LG2I0uc+cXvF4t9euHdG3MRVs
        leFye/5wxh0xlRDXgQ+0LbkQCg==
X-Google-Smtp-Source: ABdhPJwho+OC4NCsM9tp18QRNbzj72utVds3nOo574/itRkMticSlsqPskf7VH/4RgGSJE7bdgkNKw==
X-Received: by 2002:a17:903:20c:b0:154:b58:d424 with SMTP id r12-20020a170903020c00b001540b58d424mr8176251plh.45.1649249910009;
        Wed, 06 Apr 2022 05:58:30 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mr10-20020a17090b238a00b001caab109ff3sm5684971pjb.23.2022.04.06.05.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:58:29 -0700 (PDT)
Message-ID: <a211438e-5268-ba62-dd45-ad7b72a48ed5@kernel.dk>
Date:   Wed, 6 Apr 2022 06:58:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after
 io issue returns
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <f2819e9f-4445-5c5a-2a68-1d85f4bc341a@kernel.dk> <Yk0PlfaGooaFdvmm@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yk0PlfaGooaFdvmm@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/22 9:57 PM, Ming Lei wrote:
> On Tue, Apr 05, 2022 at 08:20:24PM -0600, Jens Axboe wrote:
>> On 4/3/22 5:45 AM, Ming Lei wrote:
>>> -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
>>> set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
>>> io_iopoll_check doesn't handle this situation, and io hang can be caused.
>>>
>>> Current dm io polling may return -EAGAIN after bio submission is
>>> returned, also blk-throttle might trigger this situation too.
>>
>> I don't think this is necessarily safe. Handling REQ_F_ISSUE from within
>> the issue path is fine, as the request hasn't been submitted yet and
>> hence we know that passed in structs are still stable. Once you hit it
>> when polling for it, the io_uring_enter() call to submit requests has
>> potentially already returned, and now we're in a second call where we
>> are polling for requests. If we're doing eg an IORING_OP_READV, the
>> original iovec may no longer be valid and we cannot safely re-import
>> data associated with it.
> 
> Yeah, this reissue is really not safe, thanks for the input.
> 
> I guess the only way is to complete the cqe for this situation.

At least if

io_op_defs[req->opcode].needs_async_setup

is true it isn't safe. But can't dm appropriately retry rather than
bubble up the -EAGAIN off ->iopoll?

-- 
Jens Axboe

