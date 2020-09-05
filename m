Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5025E93B
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 19:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIERLP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 13:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgIERLO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 13:11:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08A1C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 10:11:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so4633674pjx.5
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 10:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6C6Yvwa6ZFTrWo87NaDUVzP7n0udgmd/nsCCycbhWGo=;
        b=U7RrF0CZdRQnquJyAzXw5XRBs4sv+FyIvyd8QzztVZajF4eIIlVOZloIYQdpNRlTS+
         ebfrX5wBXBcZMjEx8y43jNK6gzOvOFc3vBK1FsNqrApQMe6hz9OJ4RK/rGguC2LT6dzr
         H4HNhG/iAtA+nwrEP0Z8ge22iRW8CFk+wfDRz0bfEydszNzOmeDeqws9cEbsBQoXRR8i
         SkSfISCFfuRYTtCiM4RjByHSgj4JOSj0qiWHKWGW2b2Fj1lvi/xq+mQp1cL7D0PhChww
         ZoSiPy1P5mH2PBliJloIIxtG+7T9vj82LQyCs9oK8Sa6u/U5YywnBQfHJ/hdVGUFJRP3
         j5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6C6Yvwa6ZFTrWo87NaDUVzP7n0udgmd/nsCCycbhWGo=;
        b=qqlxH/xYzUI5PYmu6QTTRccDjEa9MEZXeV3tfaMQpwhG9/ajgnR51/hmMjsAO7aNz1
         heqvVXgpZ73y5GgcMQNfVwsvoprnenBV4NM7/EDeTKOwLs8YsqLcOmfG38yP4PETkK0t
         Ve0MfR+aSsu4YT18boulj0Xqd74Emp4IZiNRR9KpEm4fecc5NrTfIYcCfr+fsCuJwJHk
         JS6as6cKWmj53XYZlCnrKCX41VdWdncJZyUJ/zD3iSWfvvaZDXBXpbkMN0U1vwxK+Js1
         T4/fk5Jq5wJWhFf1z8qiRA5eaxDv4BvfTLuC2awNovFQSYtVcDXkIpedcEtm5nGvcaA6
         MR9w==
X-Gm-Message-State: AOAM53036GAyS+ZiOOI7db854MFeoeW+bRghOVKuBY14vriRGNJnZRiS
        IVJW+MJjDbbKwU8iXj3N444ZFtAOmzsAxxU7
X-Google-Smtp-Source: ABdhPJyTatum9/7+oP+q70+lhXc7RF1Bb7Dr2/1+9UroBQOgQzRHtw+IxoHrlEJFopRuYd9H3wPemQ==
X-Received: by 2002:a17:902:7404:: with SMTP id g4mr13794165pll.176.1599325872746;
        Sat, 05 Sep 2020 10:11:12 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f10sm6390860pfk.195.2020.09.05.10.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:11:12 -0700 (PDT)
Subject: Re: Support for shutdown
To:     Norman Maurer <norman.maurer@googlemail.com>,
        io-uring@vger.kernel.org
References: <406D0D85-DF4B-4EAA-A6FA-D1EEC3F6343E@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0b53b115-cb97-bb84-6419-9e6e6b5f251d@kernel.dk>
Date:   Sat, 5 Sep 2020 11:11:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <406D0D85-DF4B-4EAA-A6FA-D1EEC3F6343E@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 11:03 AM, Norman Maurer wrote:
> Hi there,
> 
> As you may have noticed from previous emails we are currently writing
> a new transport for netty that will use io_uring under the hood for
> max performance. One thing that is missing at the moment is the
> support for “shutdown”. Shutdown is quite useful in TCP land when you
> only want to close either input or output of the connection.
> 
> Is this something you think that can be added in the future ? This
> would be a perfect addition to the already existing close support.

Something like this should do it, should just be split into having the
net part as a prep patch. I can add this to the 5.8 branch if that's
easier for you to test?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a9a625ceea5f..67714078e85d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -529,6 +529,11 @@ struct io_statx {
 	struct statx __user		*buffer;
 };
 
+struct io_shutdown {
+	struct file			*file;
+	int				how;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -666,6 +671,7 @@ struct io_kiocb {
 		struct io_splice	splice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
+		struct io_shutdown	shutdown;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -922,6 +928,9 @@ static const struct io_op_def io_op_defs[] __read_mostly = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_SHUTDOWN] = {
+		.needs_file		= 1,
+	},
 };
 
 enum io_mem_account {
@@ -3367,6 +3376,44 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	return ret;
 }
 
+static int io_shutdown_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_NET)
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
+	    sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+
+	req->shutdown.how = READ_ONCE(sqe->len);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_shutdown(struct io_kiocb *req, bool force_nonblock)
+{
+#if defined(CONFIG_NET)
+	struct socket *sock;
+	int ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	sock = sock_from_file(req->file, &ret);
+	if (unlikely(!sock))
+		return ret;
+
+	ret = __sys_shutdown_sock(sock, req->shutdown.how);
+	io_req_complete(req, ret);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5588,6 +5635,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_TEE:
 		ret = io_tee_prep(req, sqe);
 		break;
+	case IORING_OP_SHUTDOWN:
+		ret = io_shutdown_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -5942,6 +5992,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_tee(req, force_nonblock);
 		break;
+	case IORING_OP_SHUTDOWN:
+		if (req) {
+			ret = io_shutdown_prep(req, sqe);
+			if (ret < 0)
+				break;
+		}
+		ret = io_shutdown(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/socket.h b/include/linux/socket.h
index e9cb30d8cbfb..385894b4a8bb 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -436,6 +436,7 @@ extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 			     int __user *usockaddr_len);
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
+extern int __sys_shutdown_sock(struct socket *sock, int how);
 extern int __sys_shutdown(int fd, int how);
 
 extern struct ns_common *get_net_ns(struct ns_common *ns);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7539d912690b..2301c37e86cb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -132,6 +132,7 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_SHUTDOWN,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/net/socket.c b/net/socket.c
index 0c0144604f81..8616962c27bc 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2192,6 +2192,17 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
  *	Shutdown a socket.
  */
 
+int __sys_shutdown_sock(struct socket *sock, int how)
+{
+	int err;
+
+	err = security_socket_shutdown(sock, how);
+	if (!err)
+		err = sock->ops->shutdown(sock, how);
+
+	return err;
+}
+
 int __sys_shutdown(int fd, int how)
 {
 	int err, fput_needed;
@@ -2199,9 +2210,7 @@ int __sys_shutdown(int fd, int how)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_shutdown(sock, how);
-		if (!err)
-			err = sock->ops->shutdown(sock, how);
+		err = __sys_shutdown_sock(sock, how);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;

-- 
Jens Axboe

