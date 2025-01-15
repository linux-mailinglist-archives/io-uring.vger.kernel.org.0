Return-Path: <io-uring+bounces-5871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF74FA11D12
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 10:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2A7116571A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 09:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5BA246A35;
	Wed, 15 Jan 2025 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="EYvKTF3c";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rTPUsX2Y"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF11C246A05
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736932491; cv=none; b=uQKkps9VqhE9ZAQFduVUecN2N3ZWi/H5rMNL7rrh2hrPhXW8nHWcrJFMmEpkeb5yKa8MZJj49B1gIRI3DBgGa6ODuSxblGfS0L9geQzS4OiuXLAZCwPdjZJW9jLXJK4sd46Z7FrrDpyb6Pew6oPu/LRr9s7XTp7+9KrlrBrIE6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736932491; c=relaxed/simple;
	bh=Qyc5xQXiK0+aY/0FKY1g8ENtbrSnDyizPl5pLfXeH3M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KV6RzvMmNp7P/DCCN/sPOqqvy6gMEmmpK/bpfxwSwzgTXsj1MPun+qUbzPuQu0uRE5NAeNYm/2CJQL9o/HY5J1wTwoT9345DtI83TYLOoOpGNRAw/p9rC56Qg6Ny1K8kLAaH46Sj7B9eszS9g/1LtGahqti1vLjf7SMsiNGaWqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=EYvKTF3c; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rTPUsX2Y; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id D1AAA13801DC;
	Wed, 15 Jan 2025 04:14:47 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 15 Jan 2025 04:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1736932487; x=1737018887; bh=j/h8tOhehf
	hMAqUqnUQy84IBvjqb40Fk+9NPcO2oXks=; b=EYvKTF3cg01cM7tsX0hhxontqo
	40zodjD1+Lps4B/+dGMm7LOyjVT6XilpjX+0ZeJAjRRo8r+yPUH2kHZ3nXR71sGk
	SREBeaP5bxmFdEENbqpkzeE586ZtmBhZRTztKQIRysduRpQ66YSHCVa+Xz1LQzjJ
	TqR467l9KF8BWRqTa9gazA8ocdd0J0a5qZ3FINHhAPkzlgEBy0jNROqciDRW4eUb
	eiizJW/P6NuUrqiZMUZfyZWRsc9+0DVR7ycs8T+lL/T5ynQ38RqvlLf8YpZHY0y6
	g1K6R+iZWTY8FbuezK/VycvIwuDGJDJUr3X0uuL43iXtgcyWEv6fAgCGzY/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1736932487; x=
	1737018887; bh=j/h8tOhehfhMAqUqnUQy84IBvjqb40Fk+9NPcO2oXks=; b=r
	TPUsX2YB98yovx723WasraezM+28otLPNqNy+NviwpZL6plq//CI9iAVyTsmeRiW
	f8CnBMddQk5ldtYqBpld5oVvX0gasfywG2X3IFAILu9x7fAAOlioPmuZAy3mdEFf
	zFKRPBD0MDywwOLIPR8wBaZyijf8dHIzd2RhIfrkxvu/HwdFr7/ZxsJHt7RktVEm
	ftvgTgCevxb55e8EPfvDQzp1nUE9d6Lm27FV3jaHIB6wrqwOANMtyXoHdySaqjRP
	F2J66DNhrQ4LYFoNsLk78kve6hWqiqaAU3Xc1jZ7eZ1IQ9HMfRG9zodS6Cjugpui
	Vwumcf1PqFXIXo/Gvp9AA==
X-ME-Sender: <xms:h3yHZ9cKniYpchVbOEyUWn1mhjTJFtpvIglJb8aSG7l0qQBqw72H-Q>
    <xme:h3yHZ7PjMSfCUqlDjWw7k2KZAMcYgOwEIqdZWAYXRvyhvdLWTLP6ihKbrmnC57U8I
    hWGd0wegdV-woCixgY>
X-ME-Received: <xmr:h3yHZ2gdNZ0SqTydz1WFH9BAUPyuw7o5t700xW-oFYuBMIlsCSfKWggPglc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudehkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkgggtugesthdtredttddtvdenucfh
    rhhomheplfhoshhhucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvth
    htrdhorhhgqeenucggtffrrghtthgvrhhnpeduvdelheettdfgvddvleegueefudegudev
    ffekjeegffefvdeikeehvdehleekhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgpdhn
    sggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrgigsoh
    gvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgr
    ihhlrdgtohhmpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrd
    horhhg
X-ME-Proxy: <xmx:h3yHZ29hzDjkm_BNTk7npddLMQYJLf-8VNA-Kzw28dmPomo_p-pgug>
    <xmx:h3yHZ5v6Jh_BovoAM_Yr5cW-TU8cK8GeYZzHKslUC2XGe1XkvDx9QA>
    <xmx:h3yHZ1GSijr3fcJOIJ114hXTBiWF2h8DJHNdrnt97D4ZpnvE3idpSw>
    <xmx:h3yHZwOkvv8Ebg3NcYsNV7HykYuzo-c_H-i6Cs5hTABCFSq3KG7Dkw>
    <xmx:h3yHZxKRGvdKmvwE-mhw3PTYJvKfb5kRoUMb5V1ZeuvFOMYjJx3kvQk4>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Jan 2025 04:14:42 -0500 (EST)
Date: Wed, 15 Jan 2025 11:14:33 +0200
From: Josh Triplett <josh@joshtriplett.org>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: [PATCH] io_uring: Factor out a function to parse restrictions
Message-ID: <9bac2b4d1b9b9ab41c55ea3816021be847f354df.1736932318.git.josh@joshtriplett.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Preparation for subsequent work on inherited restrictions.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 io_uring/register.c | 64 +++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index fdd44914c39c..c13a34dd2255 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -104,21 +104,13 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	return id;
 }
 
-static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
-					   void __user *arg, unsigned int nr_args)
+static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
+					struct io_restriction *restrictions)
 {
 	struct io_uring_restriction *res;
 	size_t size;
 	int i, ret;
 
-	/* Restrictions allowed only if rings started disabled */
-	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EBADFD;
-
-	/* We allow only a single restrictions registration */
-	if (ctx->restrictions.registered)
-		return -EBUSY;
-
 	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
 		return -EINVAL;
 
@@ -130,47 +122,57 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
-	ret = 0;
+	ret = -EINVAL;
 
 	for (i = 0; i < nr_args; i++) {
 		switch (res[i].opcode) {
 		case IORING_RESTRICTION_REGISTER_OP:
-			if (res[i].register_op >= IORING_REGISTER_LAST) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			__set_bit(res[i].register_op,
-				  ctx->restrictions.register_op);
+			if (res[i].register_op >= IORING_REGISTER_LAST)
+				goto err;
+			__set_bit(res[i].register_op, restrictions->register_op);
 			break;
 		case IORING_RESTRICTION_SQE_OP:
-			if (res[i].sqe_op >= IORING_OP_LAST) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
+			if (res[i].sqe_op >= IORING_OP_LAST)
+				goto err;
+			__set_bit(res[i].sqe_op, restrictions->sqe_op);
 			break;
 		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
-			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
+			restrictions->sqe_flags_allowed = res[i].sqe_flags;
 			break;
 		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
-			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
+			restrictions->sqe_flags_required = res[i].sqe_flags;
 			break;
 		default:
-			ret = -EINVAL;
-			goto out;
+			goto err;
 		}
 	}
 
-out:
+	ret = 0;
+
+err:
+	kfree(res);
+	return ret;
+}
+
+static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
+					   void __user *arg, unsigned int nr_args)
+{
+	int ret;
+
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EBADFD;
+
+	/* We allow only a single restrictions registration */
+	if (ctx->restrictions.registered)
+		return -EBUSY;
+
+	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
 	/* Reset all restrictions if an error happened */
 	if (ret != 0)
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
 	else
 		ctx->restrictions.registered = true;
-
-	kfree(res);
 	return ret;
 }
 
-- 
2.48.0.rc1.219.gb6b6757d772


