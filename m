Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3107D54C57C
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbiFOKJM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbiFOKJL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:09:11 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB0E49B54
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:09:10 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s1so14656866wra.9
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+hYMjGjy8vLNY0qlLf4kmPzEsiTaG0FUI+K/qu/jh+s=;
        b=VtgtnyUJwDcKTsltCyqwlI0J/RO23YtiRMOXdp22JbZW0qx2u8YKV/9LzKIcTpJlC8
         TmkTxTXXdm9K5tqwNjGAcaHZwRMm+NjErIpSXlxXED7nhBvfqjg8aq5Nm30KgXkTtH8Z
         xllnm6tOlTQUOJuVnv0Qjx6tVZsNOeDGVTk8oORYx5oL+vpY0lfQHr5cCU9Nl/B4ul3R
         6WB3oTzQVXRBijER8SDeErbEF38f0uC1xKSmU6Ri9PKnqKtznx+SDYgIy9HFVrHW24rA
         1jIIo/Vle63BO7T9h0OG/z0jOu4qLdpHXcc04FiBluvkW6z3NULJ93qrNFq8G2/UzYHI
         Tmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+hYMjGjy8vLNY0qlLf4kmPzEsiTaG0FUI+K/qu/jh+s=;
        b=jgmilIiN1mZFAlzlFdmYASIcGXyIctWlR5KYqpknILJfbLRjZN0Bh69HEezIsFdMwi
         3Br8OSxmbwlGD4wX+EBmPiWsuePlgUw463uuXDrlZXVKb4i++6xLnhI+52s9A6SLtxB/
         mbrGPmfY5hAUo06+IFbfBMutZj/peKu53Y1SIvJAN4ja4KK03hpTpobdYDKQ9+EPAzhu
         GNL5xormd5+jEknCn8BswB7MJLjWKS6VSwa3gKRGpf9aRf06lCWcdBQno459Rf+Wx4JA
         k9gwhP1H6vMMnj05PEXE0ERwHhofQd/ByIBahMKnIuXI6yK2VYWifP2G2msO9sRPZVCR
         GeUw==
X-Gm-Message-State: AJIora+ZzFvSxg14aMBMAYB/fbLtnNC8PSqc2j66CWVUPoDCdRx314NN
        UNO2oKDVNh0BnSF/UslKjpg=
X-Google-Smtp-Source: AGRyM1s+WjiPz0Reji/7PW7aLxD1cIPn/Wu6GY3pYIqkbXFYLQClM8Sj6oSsLFjqpaqdgos7MrNkjA==
X-Received: by 2002:a05:6000:1d93:b0:20c:58f8:f530 with SMTP id bk19-20020a0560001d9300b0020c58f8f530mr8996511wrb.254.1655287748773;
        Wed, 15 Jun 2022 03:09:08 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m4-20020a056000008400b002102cc4d63asm17364300wrx.81.2022.06.15.03.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:09:08 -0700 (PDT)
Message-ID: <56f092f7-b5c4-b549-f20a-04f1bd53b49f@gmail.com>
Date:   Wed, 15 Jun 2022 11:08:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.19 2/3] Revert "io_uring: add buffer selection support
 to IORING_OP_NOP"
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1655224415.git.asml.silence@gmail.com>
 <c5012098ca6b51dfbdcb190f8c4e3c0bf1c965dc.1655224415.git.asml.silence@gmail.com>
 <477e92153bbfa3620c801dd58e8625281988ef49.camel@fb.com>
 <417f842f-0204-0f16-4355-edf7cc75dcaa@kernel.dk>
 <063bf37d245eddc309680bac4cfb10bea205dd3b.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <063bf37d245eddc309680bac4cfb10bea205dd3b.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 08:33, Dylan Yudaken wrote:
> On Tue, 2022-06-14 at 12:26 -0600, Jens Axboe wrote:
>> On 6/14/22 12:21 PM, Dylan Yudaken wrote:
>>> On Tue, 2022-06-14 at 17:51 +0100, Pavel Begunkov wrote:
>>>> This reverts commit 3d200242a6c968af321913b635fc4014b238cba4.
>>>>
>>>> Buffer selection with nops was used for debugging and
>>>> benchmarking
>>>> but
>>>> is useless in real life. Let's revert it before it's released.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>   fs/io_uring.c | 15 +--------------
>>>>   1 file changed, 1 insertion(+), 14 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index bf556f77d4ab..1b95c6750a81 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -1114,7 +1114,6 @@ static const struct io_op_def io_op_defs[]
>>>> = {
>>>>          [IORING_OP_NOP] = {
>>>>                  .audit_skip             = 1,
>>>>                  .iopoll                 = 1,
>>>> -               .buffer_select          = 1,
>>>>          },
>>>>          [IORING_OP_READV] = {
>>>>                  .needs_file             = 1,
>>>> @@ -5269,19 +5268,7 @@ static int io_nop_prep(struct io_kiocb
>>>> *req,
>>>> const struct io_uring_sqe *sqe)
>>>>    */
>>>>   static int io_nop(struct io_kiocb *req, unsigned int
>>>> issue_flags)
>>>>   {
>>>> -       unsigned int cflags;
>>>> -       void __user *buf;
>>>> -
>>>> -       if (req->flags & REQ_F_BUFFER_SELECT) {
>>>> -               size_t len = 1;
>>>> -
>>>> -               buf = io_buffer_select(req, &len, issue_flags);
>>>> -               if (!buf)
>>>> -                       return -ENOBUFS;
>>>> -       }
>>>> -
>>>> -       cflags = io_put_kbuf(req, issue_flags);
>>>> -       __io_req_complete(req, issue_flags, 0, cflags);
>>>> +       __io_req_complete(req, issue_flags, 0, 0);
>>>>          return 0;
>>>>   }
>>>>   
>>>
>>> The liburing test case I added in "buf-ring: add tests that cycle
>>> through the provided buffer ring" relies on this.
>>
>> Good point.
>>
>>> I don't mind either way if this is kept or that liburing patch is
>>> reverted, but it should be consistent. What do you think?
>>
>> It was useful for benchmarking as well, but it'd be a trivial patch
>> to
>> do for targeted testing.
>>
>> I'm fine with killing it, but can also be persuaded not to ;-)
>>
> 
> I guess it's better to kill the liburing test which can always be made
> to work with something other than NOP, than keeping code in the kernel
> just for a liburing test..

Can we do same testing but without nops? Didn't read through the tests,
but e.g. read(nr_bytes=1) and check all but the first byte?


-- 
Pavel Begunkov
