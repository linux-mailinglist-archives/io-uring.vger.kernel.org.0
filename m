Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88654D4DB4
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiCJP6N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 10:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiCJP6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 10:58:12 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7222613D902
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:57:11 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q11so6944459iod.6
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=hi0hDZzOdjPNRTcgMTw5WVe2dhmnzzaRRtPkpBAfn/o=;
        b=TaWIOltIktUYQHB7sstNrzZlMpv7b9/05YLwOTCxL+MQ+C2yAdyhuM5ypXsYCd+dEl
         iualHW0iOqotjve3xWNJH3tayxl5S9tceL82vdY06S6Wsqb33AVDoLFt9JqHfgFxUkI0
         MCcYfHs54Lb7tftu3VtkPlogKJNFU/TZlny53CLmB/C4GSgWT0jjWRZ6gOmysts70WTf
         Fon3SRNGNIEsxEoXdhgbEYENQypgYbzW2hUz9vBhMUSn8gl90ZGeGLbX/cMLxtNkND5X
         yr8sML8NmtBcVlkOxL3napX0odEBA4tzcMLLoY7xPR37rpfE8nxXahhDlFKjdmt9MH8Z
         akhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hi0hDZzOdjPNRTcgMTw5WVe2dhmnzzaRRtPkpBAfn/o=;
        b=mnSxgJUp/IBp4za1D/UF/UbHR4VRHCB4JNb/So6V3N6UDlPFs7QmbDTimjX+UmLFq3
         I/BT6zFvuqG4ElAoo1mfP0BzMCFSXD+IJjTVe/EstEDdeMq2j+Migurdl8lAkybkobco
         J7CWHAtjGZEnToRroynwiJUj1C2X/vbM8t3BHF+sa04djqgUQybDLgN+/cSPs296pxhn
         iCNCsYOru4N+gnnt59+wud9cfQLDf1xCpSpq4Hac5hTIvMvEOiQKGEdQwcQubvJrsEyV
         YbUJfaV99gyCXrsb8TCZlCpf3I4bv0BQjlIL35JcnQruVdXcWz6y2Ey5IFAFrHpVdpAg
         mBSA==
X-Gm-Message-State: AOAM5313s61y8GHdgYuHYSPVOr4wBDtOzom2t1p+cywASLj2av7IE2Tl
        xp3cvRD7SoHYW0Orn5uDrrgIOanIRLOrYAMc
X-Google-Smtp-Source: ABdhPJykzrhpYMM3Qm3gCO351AyBxM2l4FX2aFhp6jqeUHeY8FQHnfQyPRlQG3W+rrP9F77FroxRag==
X-Received: by 2002:a5e:dc05:0:b0:645:d2cc:3e92 with SMTP id b5-20020a5edc05000000b00645d2cc3e92mr4371630iok.72.1646927830746;
        Thu, 10 Mar 2022 07:57:10 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b11-20020a92c56b000000b002c76a618f52sm737898ilj.63.2022.03.10.07.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:57:10 -0800 (PST)
Message-ID: <21c3b3b6-31bb-1183-99b7-7c8ab52e953d@kernel.dk>
Date:   Thu, 10 Mar 2022 08:57:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
 <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
 <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
 <0cbbe6d4-048d-9acb-2ea4-599d41f8eb28@gmail.com>
 <1bfafa03-8f5f-be7a-37a5-f3989596ff5a@kernel.dk>
 <9a23cd0e-b7eb-6a5c-a08d-14d63f47bb05@kernel.dk>
 <22ed0dd2-9389-0468-cd92-705535b756bb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <22ed0dd2-9389-0468-cd92-705535b756bb@gmail.com>
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

On 3/10/22 8:52 AM, Artyom Pavlov wrote:
> 10.03.2022 18:46, Jens Axboe wrote:
>> On 3/10/22 8:43 AM, Jens Axboe wrote:
>>> On 3/10/22 8:36 AM, Artyom Pavlov wrote:
>>>> After thinking about it a bit, I think this approach has one serious
>>>> disadvantage: you lose successful result value of the initial request.
>>>> Imagine we submit IORING_OP_READ and link IORING_OP_WAKEUP_RING to it.
>>>> If the request is completed successfully, both ring1 and ring2 will
>>>> lose number of read bytes.
>>>
>>> But you know what the result is, otherwise you would've gotten a cqe
>>> posted if it wasn't what you asked for.
>>
>> Can also be made more explicit by setting sqe->len to what you set the
>> original request length to, and then pass that back in the cqe->res
>> instead of using the pid from the task that sent it. Then you'd have it
>> immediately available. Might make more sense than the pid, not sure
>> anyone would care about that?
> 
> Maybe I am missing something, but we only know that the request to
> which IORING_OP_WAKEUP_RING was linked completed successfully. How
> exactly do you retrieve the number of read bytes with the linking
> aproach?

Because you'd do:

sqe1 = get_sqe();
prep_sqe(sqe1);
sqe1->len = io_bytes;
sqe1->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_ON_SUCESS;

sqe2 = get_sqe();
prep_msg_ring(sqe2);
sqe2->fd = target_ring_fd;
sqe2->len = io_bytes;
sqe2->flags |= IOSQE_CQE_SKIP_ON_SUCESS;

Then when target_ring gets the cqe for the msg_ring operation, it'll
have sqe->len available. If sqe1 doesn't complete with io_bytes as the
result, the link will be broken and you'll have to handle it locally.
Which should be fine, it's not like you can't handle it locally, you
just prefer to have it handled remotely.

> Yes, passing positive result value would make more sense than PID of
> submitter, which is rarely, if ever, needed. IIUC we would not be able
> to use linking with such approach, since sqe->len has to be set in
> user code based on a received CQE, but I guess it should be fine in
> practice.

Right, and using sqe->len and passing it through makes a lot more sense
in general as you can pass whatever you want there. If you want to use
the pid, you can use it like that. Or for whatever else you'd want. That
gives you both 'len' and 'user_data' as information you can pass between
the rings.

It could also be used as `len` holding a message type, and `user_data`
holding a pointer to a struct. For example.

-- 
Jens Axboe

