Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCDB4E5251
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbiCWMjo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 08:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242773AbiCWMjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 08:39:43 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AD8DFDD
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:38:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id i184so1020132pgc.1
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ptRTD2JAq0gp8MxGYgwqB+XQfHF51awKGweQSUlPahQ=;
        b=qZM29w4szsxzWG7pE6dLZcbI9nuLxvjceEK5BOcBYDkwkmdrnUrN3YzpKvnybe+uSX
         YWXklJVBXIEpH3eRO2IDiigssbjo8FMD5Ot+HW1nkzzSXml1Q7zHhY1b6BVvbyuvKsMX
         F7fZ/53pAWYZreV9JzqeAuT+lRTL4SsLVk2kk7zpHqP/yYtTEpP2b8ONa+WUHxMVQZFu
         orZR2cwNBQZUDkxeLZXtsUf1j/ZBDeTKARUr81Hi00XwmowsCwCjddgsXYvJONkJ5tmC
         g+Np+pTA1RCf2XDh9kEg537kLIR1WSpzFtR186pdE1a0deFXM24AyPU+wtPJ0SArP21A
         DQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ptRTD2JAq0gp8MxGYgwqB+XQfHF51awKGweQSUlPahQ=;
        b=JWdRlYwZrVSP6bNTV5cGMQKjZ84W+2OKPFC+gpgfFsrhUqnj/xRe3yXe1gIps2xLCN
         6r1/aCSbp2kQ2uJQvfCEr8MC0hU6M4wZEnTLh/McB6SZ9ZLbjzIDH6K56uENgZaXjy75
         NCNzAElbw7K9CVz2RwFlPeWObCP7H3wxgm2fJwAFRo4xBeYsyTq1h6TUNdeMfRfK/rIV
         ItSUPIohI7cDQvY/m66x3YC3qW8a2OpVXM8bk+Ab6W+wmCqTmsjAopaOqptx4/GJrdeQ
         e2MzzyeE5PnM11rbfImV2Y+Z6V4Vz1irR5+y7N37NyuqQhV/iQ7MzuwWSr+MtY6uPxX1
         Pbwg==
X-Gm-Message-State: AOAM531Ge2XEmmsbYL+N97sfGwfPlD2Py0XbrM8PVyfPRu4PqxlQXaPy
        uZj6jqwtmNxo1+VTjqHl3I3Tb1VrsOOYQf+Z
X-Google-Smtp-Source: ABdhPJx1fajIccPXvzBu/SA6sEBYwSNLHCM38Y03UG7fLObm0uRUd0BWX6RU7Ujbi0OrAFQHXKaoPQ==
X-Received: by 2002:aa7:91d5:0:b0:4fa:6d3c:55d9 with SMTP id z21-20020aa791d5000000b004fa6d3c55d9mr27986613pfa.41.1648039090530;
        Wed, 23 Mar 2022 05:38:10 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id gt15-20020a17090af2cf00b001c755f3078dsm5796919pjb.50.2022.03.23.05.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 05:38:09 -0700 (PDT)
Message-ID: <32a37656-33ae-2097-b566-739cf1d951da@kernel.dk>
Date:   Wed, 23 Mar 2022 06:38:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL
 in msg_flags
Content-Language: en-US
To:     Constantine Gavrilov <CONSTG@il.ibm.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
 <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
 <DM6PR15MB2603FB4275378379A6010323FA189@DM6PR15MB2603.namprd15.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <DM6PR15MB2603FB4275378379A6010323FA189@DM6PR15MB2603.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

(please don't top post, replies go below the text you're replying to)

On 3/23/22 6:32 AM, Constantine Gavrilov wrote:
> Yes, I have a real test case. I cannot share it vebratim, but with a
> little effort I believe I can come with a simple code of
> client/server.
> 
> It seems the issue shall be directly seen from the implementation, but
> if it is not so, I will provide a sample code.

If you can, that would be useful. I took a quick look, and recv and
recvmsg handle this similarly. Are you seeing a short return, or is the
data wrong?

A bug report with a test case is always infinitely more vauable than one
that does not have one. It serves two purposes:

1) It more accurately tells us what the submitter thinks is wrong (eg
   the "this is what I expected, but this is what happened").

2) It means that we don't have to write one, which saves a lot of time.
   Ideally we end up putting it into the regression tests, which helps
   to guarantee it won't regress there again.

While you may think that we can just look at the code and fix it, a fix
needs a regression test too. And that now means that we have to write
that too...

> Forgot to mention that the issue is seen of Fedora kernel version
> 5.16.12-200.fc35.x86_64.

Thanks, forgot to ask, that's useful to know.

-- 
Jens Axboe

