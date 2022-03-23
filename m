Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847B84E5531
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiCWP1X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiCWP1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:27:22 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9996E57C
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:25:52 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b7so1220626ilm.12
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=r9JBglSFF95OQsfoRyqtyoXN2hmPbFK5YzMGEUMkpzc=;
        b=ml+FdtI47TgEk3xtDhSDpjcp822PnlLvWDSK4ltwUXO1ATqfr1y5L+/S9caagtzxTp
         6oiDux4Io3rShTgyWhnngEe8a/LO0IISniHVOyQg+wOoc8o0GVEBdm9L6JxE3zPeGAHl
         esryS9OMYmlLZ+e5fMbtKSH/JCHRZich5yGBI80lsi21lYVDCuGFq5pncF9frlIOgF5R
         2LUzxk065xp9iDl541ajqjoKDB1v6LgL95o2G4N7l3yczRjW7wPiTh2J3IBLh9reyFp1
         tgHp4iPcZU6l0O9Xjb5X/NzT4lidR+M9Q48jWo1WllS7inhP+MvEbkLx2ERf1M4gZBHy
         6QkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r9JBglSFF95OQsfoRyqtyoXN2hmPbFK5YzMGEUMkpzc=;
        b=ZqVjl6i2///mFFpSflcD8aodsC3cjP02xxKfZi1NHDC1/3UFV08ok7wm6grkE5DiHl
         HeQYr0ta8T5w7Tfy4aVqFeF01kr5ja8EZgDEup+yaydHMcIwwcls4kt8OGnM67l6E5Aa
         xHKbt5zMAiv5hidth7ckj6j6FXTrbmZe7BHA8DucNCL8SKndsvWwtvNcDW/FyFkQl2Z/
         14VdcE6ACcGfbbQa3jz/lHF39h1TaB/MHrQfeA6o1F7++eWMgBm1AZoOZSxWlDAUBRda
         fdACm72IgKJpRdqvCCdXq/BJ8mihe22ASMWCLSz+YENrxYeEzvwt2sDHP3agjDQSpTLn
         MBWw==
X-Gm-Message-State: AOAM531rghdQuy/mGPB81P6vi5R+/EAZiIQsWg8qtRlsqEjXDLyvUyrq
        2R+0vmMKCHulGWlTXuyLt36MN33RDkUEkBEO
X-Google-Smtp-Source: ABdhPJxAW3Ug25sbPMY++NPC/fSkm9YiktE+MU2d7NbmolUbSTZ12NPVRlKMYs7v5g4v6xyZRHG5ew==
X-Received: by 2002:a05:6e02:20ec:b0:2c6:158a:cb33 with SMTP id q12-20020a056e0220ec00b002c6158acb33mr296986ilv.113.1648049151915;
        Wed, 23 Mar 2022 08:25:51 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g5-20020a05660203c500b006463f6dd453sm127205iov.34.2022.03.23.08.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 08:25:51 -0700 (PDT)
Message-ID: <30518d44-6fad-c68e-ce25-0ea37c696680@kernel.dk>
Date:   Wed, 23 Mar 2022 09:25:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL
 in msg_flags
Content-Language: en-US
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>,
        io-uring@vger.kernel.org
References: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
 <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
 <DM6PR15MB2603FB4275378379A6010323FA189@DM6PR15MB2603.namprd15.prod.outlook.com>
 <DM6PR15MB2603162E692B5A68A4FD0A6FFA189@DM6PR15MB2603.namprd15.prod.outlook.com>
 <CAAL3td2kwj4Gf-q1zpVUpSgNKFKwXq0biuu7TF6um8ZAQaQo2Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAL3td2kwj4Gf-q1zpVUpSgNKFKwXq0biuu7TF6um8ZAQaQo2Q@mail.gmail.com>
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

On 3/23/22 7:12 AM, Constantine Gavrilov wrote:
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Wednesday, March 23, 2022 14:19
>> To: Constantine Gavrilov <CONSTG@il.ibm.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>> Cc: io-uring <io-uring@vger.kernel.org>
>> Subject: [EXTERNAL] Re: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL in msg_flags
>>
>> On 3/23/22 4:31 AM, Constantine Gavrilov wrote:
>>> I get partial receives on TCP socket, even though I specify
>>> MSG_WAITALL with IORING_OP_RECV opcode. Looking at tcpdump in
>>> wireshark, I see entire reassambled packet (+4k), so it is not a
>>> disconnect. The MTU is smaller than 4k.
>>>
>>> From the mailing list history, looks like this was discussed before
>>> and it seems the fix was supposed to be in. Can someone clarify the
>>> expected behavior?
>>>
>>> I do not think rsvmsg() has this issue.
>>
>> Do you have a test case? I added the io-uring list, that's the
>> appropriate forum for this kind of discussion.
>>
>> --
>> Jens Axboe
> 
> Yes, I have a real test case. I cannot share it vebratim, but with a
> little effort I believe I can come with a simple code of
> client/server.
> 
> It seems the issue shall be directly seen from the implementation, but
> if it is not so, I will provide a sample code.
> 
> Forgot to mention that the issue is seen of Fedora kernel version
> 5.16.12-200.fc35.x86_64.

Can you try with the below? Neither recv nor recvmsg handle MSG_WAITALL
correctly as far as I can tell.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 810d2bd90f4d..ee3848da885a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -612,6 +612,7 @@ struct io_sr_msg {
 	int				msg_flags;
 	int				bgid;
 	size_t				len;
+	size_t				done_io;
 };
 
 struct io_open {
@@ -782,6 +783,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_PARTIAL_IO_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -844,6 +846,8 @@ enum {
 	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
+	/* request has already done partial IO */
+	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 };
 
 struct async_poll {
@@ -1391,6 +1395,9 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return;
+	/* don't recycle if we already did IO to this buffer */
+	if (req->flags & REQ_F_PARTIAL_IO)
+		return;
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		mutex_lock(&ctx->uring_lock);
@@ -5431,12 +5438,14 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
@@ -5479,6 +5488,11 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && flags & MSG_WAITALL) {
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return io_setup_async_msg(req, kmsg);
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
@@ -5488,6 +5502,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
@@ -5538,12 +5556,23 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && flags & MSG_WAITALL) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
 		req_set_fail(req);
 	}
 
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }

-- 
Jens Axboe

