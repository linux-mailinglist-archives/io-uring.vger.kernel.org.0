Return-Path: <io-uring+bounces-2505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 615EB9304E1
	for <lists+io-uring@lfdr.de>; Sat, 13 Jul 2024 12:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02CFD281938
	for <lists+io-uring@lfdr.de>; Sat, 13 Jul 2024 10:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA4047F46;
	Sat, 13 Jul 2024 10:05:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B213E47A64
	for <io-uring@vger.kernel.org>; Sat, 13 Jul 2024 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720865107; cv=none; b=iQG3ydhmQdDy/K+Ji0rcTwhITW0P5mEc9jxTEw30y7+Jhucrl+wR+7hW2eLivMqdtjNl4hxTvRK6HZacUs5hxLBGB/sA7tHjQN9shDFDUd1apRa7uyN2X5mFl3XWengUH1DCBQZaUTcp0tIjeNGP1hmRiNPHxXYuxs1FHvoQvvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720865107; c=relaxed/simple;
	bh=atnFMaRMW2JQtNE6KgVPD17Tf5L/n8xxsXpXwJMFvZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=FY8qbIJJuTMF8iPfPym6Q6ZTyZDIVW2AiYODK4OpaQXJ4scc+Uv5S4blU2w6D/HRfRDEN6QkNoH3tb9LgGCGQEPOMJy/6zUWKC21MAHCd2jHg0Z9OoX/1NFT3cSVKhUWQb+uz4vjC7bg1eDkFyPEcGFPnbAzmF7f4+NahAQ6LaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 46DA52u4042128;
	Sat, 13 Jul 2024 19:05:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Sat, 13 Jul 2024 19:05:02 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 46DA52QI042125
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 13 Jul 2024 19:05:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <903da529-eaa3-43ef-ae41-d30f376c60cc@I-love.SAKURA.ne.jp>
Date: Sat, 13 Jul 2024 19:05:02 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH] io_uring: Check socket is valid in io_bind()/io_listen()
To: syzbot <syzbot+1e811482aa2c70afa9a0@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>,
        Jens Axboe <axboe@kernel.dk>
References: <0000000000007b7ce6061d1caec0@google.com>
Content-Language: en-US
Cc: linux-kernel@vger.kernel.org
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <0000000000007b7ce6061d1caec0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We need to check that sock_from_file(req->file) != NULL.

Reported-by: syzbot <syzbot+1e811482aa2c70afa9a0@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1e811482aa2c70afa9a0
Fixes: 7481fd93fa0a ("io_uring: Introduce IORING_OP_BIND")
Fixes: ff140cc8628a ("io_uring: Introduce IORING_OP_LISTEN")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 io_uring/net.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 69af3df4dc48c..2cfe8bb6e17f2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1741,9 +1741,13 @@ int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
 	struct io_async_msghdr *io = req->async_data;
+	struct socket *sock = sock_from_file(req->file);
 	int ret;
 
-	ret = __sys_bind_socket(sock_from_file(req->file),  &io->addr, bind->addr_len);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	ret = __sys_bind_socket(sock, &io->addr, bind->addr_len);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
@@ -1764,9 +1768,13 @@ int io_listen_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_listen(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_listen *listen = io_kiocb_to_cmd(req, struct io_listen);
+	struct socket *sock = sock_from_file(req->file);
 	int ret;
 
-	ret = __sys_listen_socket(sock_from_file(req->file), listen->backlog);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	ret = __sys_listen_socket(sock, listen->backlog);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-- 
2.43.5



