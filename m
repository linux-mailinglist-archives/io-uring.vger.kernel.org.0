Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500D751E692
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 13:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384668AbiEGLKL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 07:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384661AbiEGLKI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 07:10:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A7A45784;
        Sat,  7 May 2022 04:06:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q4so6825112plr.11;
        Sat, 07 May 2022 04:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=wESZGcNFKxrpxxsend5gLk245hMJ4SIWUC0qiFaYsPY=;
        b=qdLpdHS4co9i0tPvHe3i1K7CAJjZC1Tuqwf86FHHH3e999G3pa8SxtITWdKKomC+QB
         oBt4keJXB0dVVOYVTkEUe9LbuBqza1NCI6k4uKc08YyOFzYWmYH2yu3LIkZuW6WNA6g3
         seq3+eM23ea1f1srpMtn0Y1xsZJ4vSbLQWc91Eu2HikxLc6DCZbQbOXZhOY3Y4zW+aGd
         jhcie0NcYITMFyTdfUQaw+2vWPoyD/4dynind6V1klwL6hjAKkg9WFQFBjdr+oAlg2it
         tJmSKkQ/kLsAkhYj/EKaMXhXp3bj/gl1DwQuX7QEiimvg1NhRu/ccJfjS85FlH3sz3DF
         EcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wESZGcNFKxrpxxsend5gLk245hMJ4SIWUC0qiFaYsPY=;
        b=EYEKMn/1MIC1edgAXIbuuILhAPTz4dOfZfuOV7vJlHv2TL0fluLqlZIZb039o50yTd
         60iKpM6pcHaKdWYIjOIY9bt4kneRAENxIwPVjlzCnHG08n6x7oOv0BKNIfpSlxuGULpA
         C13KsKKTGwTjGUH3Q36jj7rccINtpnNQKhLGOkrwN5rv55xejiOONxgPq1aM55xeb8nW
         um6L/WL5JYHw+TB4MN6TQXDBED7ltg9yvIRrTk/bwg37SMFMtQb9nfjFnIpGbUMC0SQ/
         LlvoT/9cJcuT44CKFCJdCV4NKWsiGyT9hyl13xYt+o06E2/RkPt2mE48TnEKNiqagDSX
         oYzA==
X-Gm-Message-State: AOAM530erb8nwgxA6OZbmG5veWJ1TF2DAyQTKTaM955kOmaCDjEeEHR9
        P5U2MkFIZwoV2IW5Q54NGyg=
X-Google-Smtp-Source: ABdhPJxQiyVuXrP9muBdoqkdc1VjFbALVDVbBdlcrFtkrpXTwWV5bO+ulE2374FZtFiu89j6P5sIdg==
X-Received: by 2002:a17:902:9b98:b0:156:52b1:b100 with SMTP id y24-20020a1709029b9800b0015652b1b100mr7977197plp.174.1651921582078;
        Sat, 07 May 2022 04:06:22 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f70200b0015e8d4eb2cbsm3394900plo.277.2022.05.07.04.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 04:06:21 -0700 (PDT)
Message-ID: <b1775b40-3cbf-4f98-c6ea-922a48935025@gmail.com>
Date:   Sat, 7 May 2022 19:06:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
 <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
 <135b16e4-f316-cb25-9cdd-09bd63eb4aef@gmail.com>
 <acd36e44-8351-d907-bb50-57375823268c@gmail.com>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <acd36e44-8351-d907-bb50-57375823268c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 下午5:47, Pavel Begunkov 写道:
> On 5/7/22 08:08, Hao Xu wrote:
>> 在 2022/5/7 上午1:19, Pavel Begunkov 写道:
>>> On 5/6/22 08:01, Hao Xu wrote:
> [...]
>>> That looks dangerous, io_queue_sqe() usually takes the request ownership
>>> and doesn't expect that someone, i.e. io_poll_check_events(), may 
>>> still be
>>> actively using it.
>>>
>>> E.g. io_accept() fails on fd < 0, return an error,
>>> io_queue_sqe() -> io_queue_async() -> io_req_complete_failed()
>>> kills it. Then io_poll_check_events() and polling in general
>>> carry on using the freed request => UAF. Didn't look at it
>>> too carefully, but there might other similar cases.
>>>
>> I checked this when I did the coding, it seems the only case is
>> while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
>> uses req again after req recycled in io_queue_sqe() path like you
>> pointed out above, but this case should be ok since we haven't
>> reuse the struct req{} at that point.
> 
> Replied to another message with an example that I think might
> be broken, please take a look.
I saw it just now, it looks a valid case to me. Thanks.
> 
> The issue is that io_queue_sqe() was always consuming / freeing /
> redirecting / etc. requests, i.e. call it and forget about the req.
> With io_accept now it may or may not free it and not even returning
> any return code about that. This implicit knowledge is quite tricky
> to maintain.
> 
> might make more sense to "duplicate" io_queue_sqe()
> 
> ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
> // REQ_F_COMPLETE_INLINE should never happen, no check for that
> // don't care about io_arm_ltimeout(), should already be armed
> // ret handling here
This is what I'm doing for v3, indeed make more sense.

