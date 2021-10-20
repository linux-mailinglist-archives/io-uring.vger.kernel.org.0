Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA1E43472F
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhJTIrP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 04:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJTIrO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 04:47:14 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0D3C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 01:45:00 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id b189-20020a1c1bc6000000b0030da052dd4fso8339731wmb.3
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 01:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=M9zz5Ig0lUGptq8aXxjQr8TpXxCOIlBt+r3Km/yiKFE=;
        b=hljmj4LxR39mnoHvR+AB7fI7JcohoeRxFLQpt+9P7S2LkdOvbUjDm/tBi/uDRxI4zc
         FQlcqTvRkApPLedCQb+Vh3/E3kV9ehejTwZjuN0y18CP2CgUL9GTJjfpijQSyyMO0ydk
         mcfU8p8npReZh8LrIm2Bfay/eskFcm3EgHxptgvnHvtnhOteQ3JQoQdcWxW+Bm9EyQ/C
         h9hTMj+k3idRZr6EIpJ6KJ93PcEaWOVlr6plzXOTyw0nIZvXuptsTKNEa3utzevywaQz
         p3mJgWHs5DuJNxVGoukW+OeY9HVk9s/HZX92Hu8J3VNVgjlYHkbo3hn5GQydDoPORpJL
         H5Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=M9zz5Ig0lUGptq8aXxjQr8TpXxCOIlBt+r3Km/yiKFE=;
        b=ySo/6zIt3JIVKVjdftvvNDjLxi4Lc9ypVpaD4ujk7IvJ4JqGm6teytHUjT6MNJr/o6
         HF9KKEQ89Y6feRg+zBmc0FL/0B+8cYHz08aLvDIobRSbZiHlyP5XmB6uj2zAzWXKqtMp
         aMFM2soO0f1N+0Dbc1gcI6lLfYrE/eck4DrR1ncKVEIHgU7tmJPVybQ2M4spA5RftJF9
         gU9HNe7b9QUO/HUZDAF/CMQENVJn0v2P30IbqW3bAvD3pw/MkPoFshUiuYRV+jSY2bMI
         zQ6mAtjgm/tGeteTltJ4I2u9iJQZxKEsqjVB4hidVvyC1jOuPqi4guoXwZVQnIgljD0/
         WFWg==
X-Gm-Message-State: AOAM532abyFhEamQmwLt+xLLNXQar/wCsheqMSVRsTxPbeZaByZ+uE9Y
        L9yN3FbQChcaO+8q9f/TZLL87TsiVuq/Vg==
X-Google-Smtp-Source: ABdhPJz9cQiiSlqMBm2NViblxE15+j5vWaBLyUkVdKqy8SUc/lngelxC20LKQhxT+F9x9uRCRy66qw==
X-Received: by 2002:a05:600c:4fd3:: with SMTP id o19mr12011953wmq.147.1634719499188;
        Wed, 20 Oct 2021 01:44:59 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id n68sm4316812wmn.13.2021.10.20.01.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 01:44:58 -0700 (PDT)
Message-ID: <80e8c8e7-d890-51da-9e75-86510896abc2@gmail.com>
Date:   Wed, 20 Oct 2021 09:45:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 5.15] io_uring: fix ltimeout unprep
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <902042fd54ccefaa79e6e9ebf7d4bba9a6d5bfaa.1634692926.git.asml.silence@gmail.com>
 <0370d998-3fcb-d4f0-266a-3032ecff8aa8@kernel.dk>
 <37deaffe-8df5-230d-114a-99f63ae5782f@gmail.com>
In-Reply-To: <37deaffe-8df5-230d-114a-99f63ae5782f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 09:33, Pavel Begunkov wrote:
> On 10/20/21 02:48, Jens Axboe wrote:
>> On 10/19/21 7:26 PM, Pavel Begunkov wrote:
>>> io_unprep_linked_timeout() is broken, first it needs to return back
>>> REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
>>> now we refcounted it, and linked timeouts may get not executed at all,
>>> leaking a request.
>>>
>>> Just kill the unprep optimisation.
>>
>> This appears to be against something that is not 5.15, can you please
>> check the end result:
> 
> Yeah, it was 5.16 for some reason. Looks good, thanks!

Actually, it's not. We need either unprep but "smarter" or queue the
timeout. I'll send a v2 for convenience, but a fold in is below.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 36db7b76cf8d..d5cc103224f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6979,6 +6979,8 @@ static void __io_queue_sqe(struct io_kiocb *req)
  
  		switch (io_arm_poll_handler(req)) {
  		case IO_APOLL_READY:
+			if (linked_timeout)
+				io_queue_linked_timeout(linked_timeout);
  			goto issue_sqe;
  		case IO_APOLL_ABORTED:
  			/*


-- 
Pavel Begunkov
