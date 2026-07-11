Return-Path: <io-uring+bounces-13985-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id VD1sCwsgUmoiMQMAu9opvQ
	(envelope-from <io-uring+bounces-13985-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D7E741527
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IQ7fzOMN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13985-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13985-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA609303D55F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF7B3C276B;
	Sat, 11 Jul 2026 10:49:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FB23BCD1E
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:49:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766992; cv=none; b=Uy2d1B5GsgE5QWzasQKrUXr+m3jY/QABu8Ef71wy71nd3Kp71YbFIvA2lRuAEqhXqNOB/JPWEnoYu6x7FVdvv/GcItBpuXJCuEjpOx9PKmPDBMVSyvzxezPbcwmLezDhVaEednApQg3pO0tTXR0DXev7fg56hDOPOaffy0mpCrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766992; c=relaxed/simple;
	bh=qVH0rE+Dp0zBRmazSYq5tFlCk5UQ1xZNYgpiizSO5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+qq/jiDaIHRqKZnan11AmUjpQCGNzKvMMKlhVfTiEIgFGxPCaR0XxOPl0SpNZWJs3G8IXgEZMT7gE/5MUq2bKiNLQo9BGLDisDjN1wz9lTPPp8D33u4QN/x7E1rGvwfrJLM69g6nOmD+hp7+UZ5K+TC9VEspKQemcs9QvbDA2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQ7fzOMN; arc=none smtp.client-ip=209.85.218.45
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so297466366b.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766984; x=1784371784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mm11Mo8gVI7sbUw9uPDF2V0V7cWThUCpdiq94YuU6K4=;
        b=IQ7fzOMN1VCvYfvW42f9zDhOiemWAxXFQAwp56Kh1EgNo8q3C+FcrSdccnxBw9kMbm
         kl58kyPYKF29Qzkqyj7G5hnIiRnWdf3yo1mfX8LM09J76b0ElkciImc1RkUBzOyW2s+w
         hNNPcmxyMLzm5ueMQ3D530F7qLUpMBbLeVkKsokROE2G55Wp/K6RmW81l0xCg/fa2O14
         wOha6M+yv0OU53M9sOV1M4BvDDSMbXArEMUl4HX43FxFIPzInl4hakLyp3qqbdd/sM1H
         APf7UX1AvhjzaLhTDtqfnfKqn2JFDC2oWfSfmzzV5ahaxbjBolZFaQLB5Lcvs2/DQwLX
         jiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766984; x=1784371784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mm11Mo8gVI7sbUw9uPDF2V0V7cWThUCpdiq94YuU6K4=;
        b=EG1jzTHBlsKT/mCW4wZoDgDORidKLoUC9l16rdJmn8oJbz/YRvpB67MR+79uBRtOVe
         Bl3qlCBB5x1idkveUMNvXjL/4TMyQTyBx+q4Yp7PvbMPp33pZymgUVRKzIAT2eZgsZAe
         cge0VPuWdAMrSLWGSIETSsfo9RnSnL4210IZ4fFHD+Av9QEEBT/9lkqyg+I+ikINhDYB
         3Jn3CV1LZpHto8hg9uSJxtx9KZjz3NcaxE2GDhAiHWSwefGjZnaQcsGmAw1T1kvuJaGq
         W1xY4b3TxVG4r9oGA2YEIpRw7lph67J8h/U2EDJ0ZvGs3jlW8L20PAhjdw3M8Kz0m1mP
         Hyjw==
X-Forwarded-Encrypted: i=1; AHgh+RpddO8qocB7RInhg5PiQxJWyggXVvjTOhEzHs7ian4CB4ZZDZxruV+OuL+yIr8R+2noOfVWN/Gj7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoANAlpgxJ/2yd6BR+Ur7bxm9L09llPWSNwW3ONd82R7sgY+x8
	UgCMSfhRHHz0KB7Ay5dil/V/CODoDEnFfBwYLL6Ri2kLsgNd14zBojfe
X-Gm-Gg: AfdE7ckwU2b8xJPxuoutLyQTRAXmpA/1lVJ58tKrCv0p3d4z0hnlp7b/ofhh1YwUJ9x
	Lu0yDDbM9YCyERcudb0cWSUx/RnXhdq0tDg2XYt7GjIbYOjmIyVUaKriaSvysMMdaGUJxcPob3r
	NisnXiVK6doe2bRIjIXwN3yJdJsetj/Ayt+lHKRUfOl5/H738dPEYmvUKya07wJFw4wu1nyyEx7
	pVXKPbrqiWS94zZ8KZ3y51dD7ABPDhGQ5jyQNRX5syhFvP4X4QrydZpKQon/aYwGuHf0jnJm1IS
	WA0sQfLaHSGouQ7nMdKHeFzC97X7mxPpMFCt42byuW8i9iGymjuHmf7t3HpbUl/8DfyM42ZtS5M
	M4JfouBrgpINxE82usvWMQl9oHE5y4GYXqOpdJ8uCdMP0JjU3Vs9DwVsH24K/lDhe4BL9IwSAIP
	2mZwH76IdiOXN96cr6cMjn9CWUU7cxFDmRO+TKR7LfwLVF7ETpV7B7zembwtv2A40BV3jl9DSXk
	jnW+jLH+BXGYHZUuCDCjeHklCai2u3ghlt0NYkRF31AX1MtNg==
X-Received: by 2002:a17:907:c510:b0:c12:8c41:3beb with SMTP id a640c23a62f3a-c161eaa5c2bmr89717366b.50.1783766983872;
        Sat, 11 Jul 2026 03:49:43 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15beb53b86sm609123166b.25.2026.07.11.03.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:49:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 10/10] io_uring/net: implement device memory send
Date: Sat, 11 Jul 2026 11:48:39 +0100
Message-ID: <ad3d2185448cf828c65336fa4b71233098473a4a.1783614400.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783614400.git.asml.silence@gmail.com>
References: <cover.1783614400.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,mojatatu.com,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13985-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:netdev@vger.kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:jhs@mojatatu.com,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 91D7E741527

Enable zerocopy sends with device memory by teaching it how to work with
IO_REGBUF_TYPE_ZCRX. There is no iterator type to represent what we
need, so do a little hack, pass an iovec instead and let a custom
sg_from_iter implementation to fill skbs with netmems.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 29 ++++++++++++++++++++++++-----
 io_uring/notif.h |  5 ++++-
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cf273d6f02b1..2ffbb59ceee4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1497,6 +1497,14 @@ static int io_sg_from_iter(struct sk_buff *skb, struct ubuf_info *ubuf,
 	return ret;
 }
 
+static int io_sg_from_zcrx_iter(struct sk_buff *skb, struct ubuf_info *ubuf,
+				struct iov_iter *from, size_t length)
+{
+	struct io_notif_data *nd = container_of(ubuf, struct io_notif_data, uarg);
+
+	return io_zcrx_fill_tx_skb(skb, nd->zcrx, from, length);
+}
+
 static int io_send_zc_import(struct io_kiocb *req,
 			     struct io_async_msghdr *kmsg,
 			     unsigned int issue_flags)
@@ -1510,15 +1518,17 @@ static int io_send_zc_import(struct io_kiocb *req,
 	notif->buf_index = req->buf_index;
 
 	if (!(sr->flags & IORING_SEND_VECTORIZED)) {
-		ret = io_import_reg_buf(notif, &kmsg->msg.msg_iter,
-					(u64)(uintptr_t)sr->buf, sr->len,
-					ITER_SOURCE, issue_flags);
+		ret = __io_import_reg_buf(notif, &kmsg->msg.msg_iter,
+					  (u64)(uintptr_t)sr->buf, sr->len,
+					  ITER_SOURCE, issue_flags,
+					  IO_REGBUF_IMPORT_ALLOW_ZCRX);
 	} else {
 		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
 
-		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter,
+		ret = __io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter,
 					notif, &kmsg->vec, uvec_segs,
-					issue_flags);
+					issue_flags,
+					IO_REGBUF_IMPORT_ALLOW_ZCRX);
 	}
 
 	if (unlikely(ret))
@@ -1545,9 +1555,18 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		struct io_mapped_ubuf *buf;
+
 		ret = io_send_zc_import(req, kmsg, issue_flags);
 		if (unlikely(ret))
 			return ret;
+
+		buf = sr->notif->buf_node->buf;
+
+		if (buf->flags & IO_REGBUF_TYPE_ZCRX) {
+			kmsg->msg.sg_from_iter = io_sg_from_zcrx_iter;
+			io_notif_to_data(sr->notif)->zcrx = buf->priv;
+		}
 	}
 
 	msg_flags = sr->msg_flags;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index f3589cfef4a9..2dfd5bf23302 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -17,7 +17,10 @@ struct io_notif_data {
 	struct io_notif_data	*next;
 	struct io_notif_data	*head;
 
-	unsigned		account_pages;
+	union {
+		unsigned		account_pages;
+		void			*zcrx;
+	};
 	bool			zc_report;
 	bool			zc_used;
 	bool			zc_copied;
-- 
2.54.0


