Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07272176B8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 20:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgGGS3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 14:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgGGS3U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 14:29:20 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400A9C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 11:29:20 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id e64so39324933iof.12
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 11:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SuRgvMFCkZPRQnPVzeoUFUe1ABt0kG1e6AqtwKqNzhg=;
        b=IBgrFpRX+v7t2H5LBFzBpkJP5u59s82O8fg/DqUTMVuXLa7b+pJa8UeapO+yj43u6l
         GZHgi2zwCoB0JQrEJdXKKD7ikH4kil6uEaFN0KTUkGM3ATN6GihE/A8WQoo7D0jmM2X1
         V7D2LKVkrukFZYRcTOjk/CXg7d99z2cvWjzzBS2JdKeeQRUKXlgQnnfnqqEkxPQih+RA
         W6mQQTNU11f7AdqgZ/erAjgp5w0V7ztYPRzfb9+RoYj+GQIuETDBnaWgfA/+7Y7ns/Ho
         ztRM98rzlgk4B26KVdobLDT4pm/OxIZwmoGXAIE3LATziy9+kMQod18IEa7ffdmgwhsP
         dsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuRgvMFCkZPRQnPVzeoUFUe1ABt0kG1e6AqtwKqNzhg=;
        b=OANzYNM25iF6OLPHVoOZYQN/3CEEKnXdS5e7ehqYn8suy7zC7dKPiOnAd8sx4LUohh
         Rl4A/7At5yj1mbZU/PJWMIp3HxnTOhSpNEXZzOJN+X+cpQWAZbE+gmkbxoIFjpjCf9sh
         PhffqXtgR8hR+on2CC3R9/qg4aCyiBzmKrVyW3eLj33otgbaKzpiQSjm133Thrutljux
         X8V7UfsqHftM8an+YEKAhvUUYLJFVCfeR2B1eDM+iEOvISNb5ZCBzT4m5/zxwI7PkR9Q
         zktxG3lf+imD5+ui75Mupe+A1SSuVdZTxQMs78YCKUnufhrcTZbHP6D0iRFm6MlT++Xa
         a18w==
X-Gm-Message-State: AOAM531rQX50yRssG6d79fxc/pzS+Oyahs9Llen8s44Hp8PaQqlISWRu
        iStlHhW7PorxTdKJsYaLKiOG7hvVmBP9Aw==
X-Google-Smtp-Source: ABdhPJwcTTvXEEuJ4XR9cGoSxFIlyeaNy/vkJsLp6l45iOpYPpTYJLk4bpo3n5LmSgbRcpW1Pgngpg==
X-Received: by 2002:a6b:197:: with SMTP id 145mr32467362iob.77.1594146559304;
        Tue, 07 Jul 2020 11:29:19 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t6sm12141714ioi.20.2020.07.07.11.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 11:29:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add support for sendto(2) and recvfrom(2)
From:   Jens Axboe <axboe@kernel.dk>
To:     Alex Nash <nash@vailsys.com>, io-uring@vger.kernel.org
References: <20200706180928.10752-1-nash@vailsys.com>
 <fdd60247-293c-a510-9a67-8428bd7456e8@kernel.dk>
Message-ID: <a2399c89-2c45-375c-7395-b5caf556ec3d@kernel.dk>
Date:   Tue, 7 Jul 2020 12:29:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fdd60247-293c-a510-9a67-8428bd7456e8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/20 2:44 PM, Jens Axboe wrote:
> On 7/6/20 12:09 PM, Alex Nash wrote:
>> This adds IORING_OP_SENDTO for sendto(2) support, and IORING_OP_RECVFROM
>> for recvfrom(2) support.
> 
> I'll ask the basic question that Jann also asked last week - why sendto
> and recvfrom, when you can use recvmsg and sendmsg to achieve the same
> thing?

In a private conversation with the author, a good point was brought up that
the sendto/recvfrom do not require an allocation of an async context, if we
need to defer or go async with the request. I think that's a major win, to
be honest. There are other benefits as well (like shorter path), but to me,
the async less part is nice and will reduce overhead.

For the patch itself, a few comments below:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4c9a494c9f9f..b0783fbe1638 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -415,7 +415,14 @@ struct io_sr_msg {
 	struct file			*file;
 	union {
 		struct user_msghdr __user *msg;
-		void __user		*buf;
+		struct {
+			void __user	*buf;
+			struct sockaddr __user *addr;
+			union {
+			void __user	*recvfrom_addr_len;
+			size_t		sendto_addr_len;
+			};
+		} sr;
 	};
 	int				msg_flags;
 	int				bgid;

Some inconsistent indentation here.

@@ -876,6 +883,18 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_SENDTO] = {
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+	},
+	[IORING_OP_RECVFROM] = {
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+	},
 };

RECVFROM should have pollin set, not pollout?
 
 enum io_mem_account {
@@ -3910,6 +3929,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
+	if (req->opcode == IORING_OP_SENDTO) {
+		sr->sr.addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sr.sendto_addr_len = READ_ONCE(sqe->sendto_addr_len);
+		return 0;
+	}
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;

Might be better with a switch for the opcode here since we're now doing
three ops in that prep?

@@ -4148,6 +4181,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
+	if (req->opcode == IORING_OP_RECVFROM) {
+		sr->sr.addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sr.recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->recvfrom_addr_len));
+		return 0;
+	}
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;

Same comment here.

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8d033961cb78..62605e4aabd2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -56,6 +56,10 @@ struct io_uring_sqe {
 			/* personality to use, if used */
 			__u16	personality;
 			__s32	splice_fd_in;
+			union {
+				__u32	sendto_addr_len;
+				__u64	recvfrom_addr_len;
+			};
 		};
 		__u64	__pad2[3];
 	};

I guess we have no more room in the "regular" parts of the SQE with
recvfrom/sendto taking 6 arguments?

-- 
Jens Axboe

