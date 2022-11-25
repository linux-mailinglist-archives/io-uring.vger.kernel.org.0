Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00966638BA3
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 14:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKYNzK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 08:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiKYNzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 08:55:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268EDB482
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:55:08 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ci10so3773330pjb.1
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KLu9pnPpemQAE/R5bONqX9gmqN7BfuQH6h5mNId4B/A=;
        b=hPfX0d6BbcoJHueQgcHmtq+iqisr6lBS2CSRV0o3sEZnt8DGWxYqo5eMZDiR9x2CIL
         pBF5pUlpzpFv0YBwxMohKIBkuqpaymKBycul1vN+Heb4x4OWPw/yrVfnhPuSA/uriqwP
         Bm610IyPHzIX1n4BrByO874Rak7U0fllDEOnTQ2DcMa/ZCZQrQsZZtRuGat0ZQ9hpSwC
         t795Aqlnhu0U8yRLtSXa9nFa9Is9GhWUfvaN5WViESMrdGZ3AmGZW/51Wuu5vzfmvF+t
         EKwPrs96nY//ngalsZJcZ+SWo1Fj7KSdDS4EYyMKdcqs5Rjn5MHGUvUAEuP93eFP0SFd
         0OBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLu9pnPpemQAE/R5bONqX9gmqN7BfuQH6h5mNId4B/A=;
        b=YIh7QGYMulXdYD0njBxgKORHGPiheM3QdWZ3NGkn73jAzSGGEteeD3CfwSOWHtZ4dY
         fsVh5d0LrSRb47LQK6yS1Zmmv0MGPW8uafpic73y2lSQoareKM7JPZ4BxrAXFoxotMs4
         u9W8f7F/XMsAtpsV6CENBhCTW4M2V1ZoiFlJoF2bGt1WkUQa1Yl2/fzghHzGc+FTkyMe
         vO/dnFfHysZCI5cfHNQYu5gDuWlLb+1iHHFpgZeY5tQ1hvb8ZIAPiSw1zOs9N3B7aJDH
         RJIw9rAsLuDQywevZwWSAHazKHKNGIpwrerL+luCVj2iJLaQnQPC06vFQAt8SrXsctKk
         EkBQ==
X-Gm-Message-State: ANoB5pkb84XAA5R1jLvwBLpAxw/q3+xS8UwhxdCgLVhGa5IN8qim4qB2
        L4Pb/BL0i8fRJEdE2M0Ch4clB1FCp4GwNP51
X-Google-Smtp-Source: AA0mqf7XzS+CHY6G+cJpXliHNVHv4X4EN5wWJp+daHIWo5m8SKtJHFvNXol+uwfCH0H9iXlCVSmVNA==
X-Received: by 2002:a17:902:f155:b0:189:33cd:648 with SMTP id d21-20020a170902f15500b0018933cd0648mr17947426plb.134.1669384507547;
        Fri, 25 Nov 2022 05:55:07 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n20-20020a170902d0d400b00186fb8f931asm3361215pln.206.2022.11.25.05.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 05:55:07 -0800 (PST)
Message-ID: <b72ee45b-5b7f-48a7-0eb6-e7a921013e2a@kernel.dk>
Date:   Fri, 25 Nov 2022 06:55:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/2] io_uring: cmpxchg for poll arm refs release
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1668963050.git.asml.silence@gmail.com>
 <0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com>
 <99745f3e-9956-9a7a-b3e2-ef46422d2b26@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <99745f3e-9956-9a7a-b3e2-ef46422d2b26@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/25/22 6:51 AM, Pavel Begunkov wrote:
> On 11/20/22 16:57, Pavel Begunkov wrote:
>> Replace atomically substracting the ownership reference at the end of
>> arming a poll with a cmpxchg. We try to release ownership by setting 0
>> assuming that poll_refs didn't change while we were arming. If it did
>> change, we keep the ownership and use it to queue a tw, which is fully
>> capable to process all events and (even tolerates spurious wake ups).
>>
>> It's a bit more elegant as we reduce races b/w setting the cancellation
>> flag and getting refs with this release, and with that we don't have to
>> worry about any kinds of underflows. It's not the fastest path for
>> polling. The performance difference b/w cmpxchg and atomic dec is
>> usually negligible and it's not the fastest path.
> 
> Jens, can you add a couple of tags? Not a fix but the second patch
> depends on it but applies cleanly even without 1/2, which may mess
> things up.
> 
> Cc: stable@vger.kernel.org
> Fixes: aa43477b04025 ("io_uring: poll rework")

Sure, done.

-- 
Jens Axboe


