Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115451BAE81
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgD0Txe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 15:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgD0Txe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 15:53:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EAAC03C1A7
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 12:53:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r4so9155607pgg.4
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 12:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5AiPUPtxCiQvboDcS7WV9GxwIxTvQgyLFjgwai7neR0=;
        b=VIdN1O5xc19M9dx4Ci9nIupBEOXDT9KwVNDlCxEDwM05P2iT/hQRjSznkp5TLDcm6s
         QEvcgEo5+ebBnToE6VumN4utl8SJuzcsEgM0/VlhYaBQw2D5Y2Y9Ou5dSa9O02Rh9w1/
         Fow3X0E+zzTGF5XkVy6TfZ8P15H0kd7YnWI5prpdfhHXKYz+YGIEGJJmLCZ4tDcBcoJV
         5xnRP/NqHQzaR4iPk28TS4j1ug0P6gj3Fvpt79/ybPMSH5HgmKmBqgszwSaJUoyzJ8qD
         KsSl4hQMfgxlF4pW2B7MPpbY66nqhKvKaklkoC+dxpxdzlzxTiA3cp+p0DOaoWaKqGWq
         MXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5AiPUPtxCiQvboDcS7WV9GxwIxTvQgyLFjgwai7neR0=;
        b=QWdwqpqdLWha5wm90UDxjF/0cSAE5OJa3+l4vLVZABQCzHN8+UNMPYWoX2NFJwId8s
         jltpy+jk5o5qaXwVyJBNoF/3kA6olHnjUHdCdmtbGga7XF7fhINMz6Pk37ykWQKD//DW
         N6yuumXvCbasorEG31LRzQ4v1SBaM0nzj1BJEX4rx8HIVvNyssog7CGl9O7eF3osMxc5
         idUJhCa79+j3tISRdoTqFSyBqFLxxe54w1KWyoPYBWAwL+SOGrZQAM135YxGgXIt1qql
         7a9dMwn89K9PHxmdQ3OrH/hbHaWqcryWqGqwnBPjHeQ93cu8ztogXEWWMUNfSuYdWGpI
         fqDg==
X-Gm-Message-State: AGi0PuYz0P2MYKvYjLyioFwcMKYPC7zIPB3hf/coyQRMUW/j7c64n03w
        zz2z0CKcBUqMpXdpYJnGx5ntA4RJJfIAGA==
X-Google-Smtp-Source: APiQypJKxxqFqmpZHyA+DwcGbOmZlh/e2LGW5KFClgYxJ5y7OTNePNAmOF27D1Nz+qI/9ioAWOZV6A==
X-Received: by 2002:aa7:9802:: with SMTP id e2mr25259557pfl.213.1588017212490;
        Mon, 27 Apr 2020 12:53:32 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i9sm13075644pfk.199.2020.04.27.12.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 12:53:31 -0700 (PDT)
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
 <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
 <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk>
Message-ID: <45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk>
Date:   Mon, 27 Apr 2020 13:53:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 1:29 PM, Jens Axboe wrote:
> On 4/27/20 1:20 PM, Jann Horn wrote:
>> On Sat, Apr 25, 2020 at 10:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 4/25/20 11:29 AM, Andreas Smas wrote:
>>>> Hi,
>>>>
>>>> Tried to use io_uring with OP_RECVMSG with ancillary buffers (for my
>>>> particular use case I'm using SO_TIMESTAMP for incoming UDP packets).
>>>>
>>>> These submissions fail with EINVAL due to the check in __sys_recvmsg_sock().
>>>>
>>>> The following hack fixes the problem for me and I get valid timestamps
>>>> back. Not suggesting this is the real fix as I'm not sure what the
>>>> implications of this is.
>>>>
>>>> Any insight into this would be much appreciated.
>>>
>>> It was originally disabled because of a security issue, but I do think
>>> it's safe to enable again.
>>>
>>> Adding the io-uring list and Jann as well, leaving patch intact below.
>>>
>>>> diff --git a/net/socket.c b/net/socket.c
>>>> index 2dd739fba866..689f41f4156e 100644
>>>> --- a/net/socket.c
>>>> +++ b/net/socket.c
>>>> @@ -2637,10 +2637,6 @@ long __sys_recvmsg_sock(struct socket *sock,
>>>> struct msghdr *msg,
>>>>                         struct user_msghdr __user *umsg,
>>>>                         struct sockaddr __user *uaddr, unsigned int flags)
>>>>  {
>>>> -       /* disallow ancillary data requests from this path */
>>>> -       if (msg->msg_control || msg->msg_controllen)
>>>> -               return -EINVAL;
>>>> -
>>>>         return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
>>>>  }
>>
>> I think that's hard to get right. In particular, unix domain sockets
>> can currently pass file descriptors in control data - so you'd need to
>> set the file_table flag for recvmsg and sendmsg. And I'm not sure
>> whether, to make this robust, there should be a whitelist of types of
>> control messages that are permitted to be used with io_uring, or
>> something like that...
>>
>> I think of ancillary buffers as being kind of like ioctl handlers in
>> this regard.
> 
> Good point. I'll send out something that hopefully will be enough to
> be useful, whole not allowing anything randomly.

That things is a bit of a mess... How about something like this for
starters?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 084dfade5cda..40aa5b38367e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3570,6 +3570,37 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return ret;
 }
 
+static bool __io_net_allow_cmsg(struct cmsghdr *cmsg)
+{
+	switch (cmsg->cmsg_level) {
+	case SOL_SOCKET:
+		if (cmsg->cmsg_type != SCM_RIGHTS &&
+		    cmsg->cmsg_type != SCM_CREDENTIALS)
+			return true;
+		return false;
+	case SOL_IP:
+	case SOL_TCP:
+	case SOL_IPV6:
+	case SOL_ICMPV6:
+	case SOL_SCTP:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool io_net_allow_cmsg(struct msghdr *msg)
+{
+	struct cmsghdr *cmsg;
+
+	for_each_cmsghdr(cmsg, msg) {
+		if (!__io_net_allow_cmsg(cmsg))
+			return false;
+	}
+
+	return true;
+}
+
 static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_async_msghdr *kmsg = NULL;
@@ -3604,6 +3635,11 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 				return ret;
 		}
 
+		if (!io_net_allow_cmsg(&kmsg->msg)) {
+			ret = -EINVAL;
+			goto err;
+		}
+
 		flags = req->sr_msg.msg_flags;
 		if (flags & MSG_DONTWAIT)
 			req->flags |= REQ_F_NOWAIT;
@@ -3617,6 +3653,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 	}
 
+err:
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -3840,6 +3877,11 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 				return ret;
 		}
 
+		if (!io_net_allow_cmsg(&kmsg->msg)) {
+			ret = -EINVAL;
+			goto err;
+		}
+
 		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
 		if (IS_ERR(kbuf)) {
 			return PTR_ERR(kbuf);
@@ -3863,6 +3905,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 	}
 
+err:
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
diff --git a/net/socket.c b/net/socket.c
index 2dd739fba866..78cdf9a8cf73 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2425,10 +2425,6 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
-
 	return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
 
@@ -2637,10 +2633,6 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			struct user_msghdr __user *umsg,
 			struct sockaddr __user *uaddr, unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
-
 	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
 }

-- 
Jens Axboe

