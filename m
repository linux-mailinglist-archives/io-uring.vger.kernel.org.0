Return-Path: <io-uring+bounces-11216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF679CCC5F9
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 16:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54E7D30671F3
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 15:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803EB2D2384;
	Thu, 18 Dec 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BoULUcEc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03DD28850C
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766070089; cv=none; b=KjClpBQncgWQXgL/h02mU/t+0pRJeQfv6zIyIjHQjz131Y5xGoiQ6y39o4AKvPu498ffmaDeHyaRjytr7JM9Vu+CikrpNIJe48GNZvYh25iQmzlmEPzkm4B4vGxNYwH/Agxfl+Pqw8jsWAqgqwQWX7IvwsBtr2juhNdtzUDhcEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766070089; c=relaxed/simple;
	bh=hiSbs61OIjTcRTzp9UQFIu9CG9N66NuLp5WpyamzTtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrRPeWFYfWDYm4qbGK5bUUB3p6HxwlpqChScL7fW4pqoLAHiqct2e6dIxNPDFiHrk5ZPzopt2sU0Vc4rulFZ01xNbSn4BXU6FN0AfupSLH5xW7WsFFjgJh5b8DMRwJCGmPJwO9LB/f61Yetjz003zXuJ6aZquY50LNxKVM6XGWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BoULUcEc; arc=none smtp.client-ip=209.85.167.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-455bef556a8so460875b6e.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 07:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766070086; x=1766674886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/jNunAP/XexBrNihPEinGvq4upYrJbCX1IEM6GCAi8=;
        b=BoULUcEcY1hlHfjNWj9E+jZx4G6OWpdlh+u0ibYsRc/y6SqR8nVfY4KzcNHyAra0vz
         6x6z/exP8t632xqNr6tHU535vqOTVvy9ghHyNbH0qGHquS00/2NvSaF0a7vR0y7LbYbB
         eqBCQvIsOIernzfSPplr0QsoGY6tnMn13SG6rCksASYbRbiMUzp4XXLKnRGiiykpGewg
         1XPlH+w8W6hbAjvbNN/r6/35Xq1AFwYnBigPLZGuaDs6QEdPJVEBKsse11eWd2COt5+A
         DxFk6yuedV7IlQiECQ6v9jBpclV/aPnOJGm4nFVC0muH5I56wH4O3TY93phVFWt44F9Z
         nb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766070086; x=1766674886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O/jNunAP/XexBrNihPEinGvq4upYrJbCX1IEM6GCAi8=;
        b=KYQHkk/19zrmzCqiDZnDAFVfQY+TNuDfEAqEBmQejgj8xxJCCZKN+1vO4uumTafFSZ
         vt8eTi6n9QRHUUvol+1oGT3fOqeIrbp377q2ietHq+Z6bPxV6VbjLoCc5/+/TvwHU7YU
         Ae/sSkR/Dxo03809ZsKU9BJU8JCEWLPnOh4jVW023FM3TaMK4xqGcinRAmykNFoSfZmt
         hhU/l4IhElwV8y+0mQOSepHRd36SXET3o2OhQV3T2X+Jw9vqz9Z4dDPKriA3lryK9n0s
         oPoks/KY2K9MqghUAQ1EkArSO4i5SrlV7p2cb9dXUycKUf1zxo9t6vzLL/I2OmShbjfn
         sz0A==
X-Gm-Message-State: AOJu0YziCL6+1PzGKV5a/TYFzb3GGYailUPGGDJUXYs2WLn2YsON6QL6
	dgcEeK6+FEgqfO6O3zMYt/oRVN6dusETOkHGn6/vX5ihTr/ujJ5lskYIMiWFnRJj/rJdWL0M15B
	XxF3UJfgD3w==
X-Gm-Gg: AY/fxX6Dymrw//n4hk1T5MEjOziSlvCpnXYHIqKQQ6J7c8Dffse6LbArZSypyG1KYAu
	nfPEhMfYxZR9be2N8mE9r21fz52scHWAyLGqyLSp36kXPqAUaYVnVR5x4DT2p2P2WSZw4Xvlfrf
	UqxyrfbmVMi5EuAFcfWurFesnfFGvcVVqDpQhcXjNU0H0ZNgIG7wlZ8fzTKPKMdp0oX6e4WNYKr
	8zAJQ/m4hulujlfPhPm2k8Ky+lUMC21XbMhWUITtdwvREbuDp8V1UD9s8OWpAHSxHAh4IsjVHEw
	8aoV5/Os0EtZD5tu589/WM0NP7O8+PBLgkjxUQ7Ou21FByMErvV4IWfMrmXS3ljMID7tDhmShaU
	yx2djQbg0UYjNsvijIjSJQowy5PSQqN8HDQFLNofCoA8qZdBUelUhzcOtQ4KwfiuGr5jGYQ==
X-Google-Smtp-Source: AGHT+IHcYe7sSib0lg91kOUIhVupSIaIoKNxM+L1A4aHwxSYJL3cMcboQJuv15Y2yYh1pKS9l6Hcgw==
X-Received: by 2002:a05:6808:a5cf:10b0:450:b64e:9c14 with SMTP id 5614622812f47-455ac7efc63mr8110183b6e.5.1766070086090;
        Thu, 18 Dec 2025 07:01:26 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457a42fe963sm1327816b6e.1.2025.12.18.07.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:01:22 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	kuba@kernel.org,
	kuniyu@google.com,
	willemb@google.com,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>
Subject: [PATCH 1/2] af_unix: don't post cmsg for SO_INQ unless explicitly asked for
Date: Thu, 18 Dec 2025 07:59:13 -0700
Message-ID: <20251218150114.250048-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251218150114.250048-1-axboe@kernel.dk>
References: <20251218150114.250048-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but
it posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
incorrect, as ->msg_get_inq is just the caller asking for the remainder
to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
original commit states that this is done to make sockets
io_uring-friendly", but it's actually incorrect as io_uring doesn't
use cmsg headers internally at all, and it's actively wrong as this
means that cmsg's are always posted if someone does recvmsg via
io_uring.

Fix that up by only posting cmsg if u->recvmsg_inq is set.

Cc: stable@vger.kernel.org
Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
Reported-by: Julian Orth <ju.orth@gmail.com>
Link: https://github.com/axboe/liburing/issues/1509
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/unix/af_unix.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 55cdebfa0da0..110d716087b5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3086,12 +3086,16 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 
 	mutex_unlock(&u->iolock);
 	if (msg) {
+		bool do_cmsg;
+
 		scm_recv_unix(sock, msg, &scm, flags);
 
-		if (READ_ONCE(u->recvmsg_inq) || msg->msg_get_inq) {
+		do_cmsg = READ_ONCE(u->recvmsg_inq);
+		if (do_cmsg || msg->msg_get_inq) {
 			msg->msg_inq = READ_ONCE(u->inq_len);
-			put_cmsg(msg, SOL_SOCKET, SCM_INQ,
-				 sizeof(msg->msg_inq), &msg->msg_inq);
+			if (do_cmsg)
+				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
+					 sizeof(msg->msg_inq), &msg->msg_inq);
 		}
 	} else {
 		scm_destroy(&scm);
-- 
2.51.0


