Return-Path: <io-uring+bounces-12593-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEFhJszarmm/JQIAu9opvQ
	(envelope-from <io-uring+bounces-12593-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 15:35:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D01D23A996
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 15:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A026E30266F6
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 14:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18C03D332F;
	Mon,  9 Mar 2026 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhC0I1Rz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4A23BFE34
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773066894; cv=none; b=ZFVKSdyza1hby5qATlT0uT1vwzzeUBQ5sxRs9kwbyJxme7c9EuR4z57L5WxCV+GbKLcFIuSdUQqvL9emOE5JTy9Jn7ivhtoAv2ObBkOLKbgiBZXD2xA0WkpOH55chzzHrGym6yYSto/76rOZOUuLRXv2XY0aWdoB6sINcP/DCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773066894; c=relaxed/simple;
	bh=QgwdfBmJtLUH70M5vhjZqONdVk/cg4rv3tFR0/ljb+U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uCO75VCxoBfV9zFW/8wjF4SB4AVohwy/yX7z/o1CiSBLthPJ6+o8SJLcc/TLdRmBIs52Tw+J/AWy9GygSjLmBtgAVLm2Y1RPzq3QCn04jE9ZgrZuKB7Mwc6P6bEUOYl0S1ywrK89JwLQldpp501yuZ7y6r/QZzf+rIqeQ+PUySs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhC0I1Rz; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-485317b6bd0so91815e9.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 07:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773066890; x=1773671690; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dGGuXh0JCx+P2zcPdhk2MDVsfn+ACpfwvVPqCyhcMyk=;
        b=zhC0I1Rz2CREas4rm33lIRnvYTJiroqRa74OmDTe54NkS9kxYu6fHwDvFiDR71Vqn6
         O1Tnjjv3a2bTNt0yZLXGtZDPEp3ANenH/62rQAUyZp4XJH+1jAUnZKXJQnE6xDew4cPd
         nMVzE8pjHnCMO1icD46iNLQSbccuXzxvw5x7Nn/esIt/cAsf0VSp52iZ5Qen8xEi7EjZ
         wES7YmjITeFaT7qzmelrHUeHZdwhtYnQDwS7ucrii+AE2s2+tlI4lEeXr/p+JD9ZAV8r
         GHD4QbFzLddDNm0tU3zeQtkuYBq5cpgBtwYEEit2qLPJrmcfc4SKHAF6RLT44eHXwZwR
         zHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773066890; x=1773671690;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGGuXh0JCx+P2zcPdhk2MDVsfn+ACpfwvVPqCyhcMyk=;
        b=aGLA3B6zd96MGmqRe16vjUXI1hyWXEVi1eq2Y6onjmPK/cpvW6e4oFaewXLysBg1Yd
         Wf55cRrJFFyZb7939CU7x8HI453fOrQYGRO4o71tA42VQbJSS6R5iN08UJR7sbSci9j9
         lMp1nDBD2Qqqc4PhCchJdQYcdcIDOQm98+0FCg7OXHf19eOWXxGjKPEOUHaGrYj4PUp0
         /HQLDdipffPNJN47U/+qOWVd9Ncz2X9h5ub8OPiPB/KsQRrmuHI7wfASfkZ7w3y4+ZzE
         AoPddu8nieercv+4sGhYqJWQtWi4l4/+MIusUuQhBLj5tZzG6ghcTFOlD8g1o9qiRnTa
         RanQ==
X-Gm-Message-State: AOJu0YwMyvppk+ek1+E3lNSHaXgo0OtTTbARbU39e52HElptU5XxhVPm
	zOSKSvLq0+wqSrvce1XxYr6Ny7VtkPW1JXuvSWFojzy46NHSvUd/863AuKh6z2W/5w==
X-Gm-Gg: ATEYQzx0OPLq5jm3uMgf9vAG0wpr5TI9wCZ+M44SvBOtXxVVyCQ08/CE/+ZvASysIKt
	xaEveJrQj3mHM8yBFV6CHS7QXQ3AWsrP4seLI4gnQMJJRrHbUeWehQl5ygaJ3/FTEUL+LqUfW2s
	fefNIGDWBL6UuxQj1qX0JN9FGydsDZJQz0e4C+noAyg/lnogTBBiCH8EszmNcyRBQPXYFqyEZDF
	KffcTZ0Z2xN20RLyx1BMrJ89+fgIvxiKHKvCyH7zq4h4jyab6MLpoGhSCi9egtjKP+IX/bVtK/p
	DbGj0iuztiuYJZD0njzxglMMeq+xAk3K/wsI+8v75BlIAf/opUOgrL0G6f6lrO5Vh8Ib9IE4ffx
	hGuFVV4SZ7m1E4aphemm5yHY1DKcM5gZVbVFUoStuyJJxosKo0Piw6UWatUzYhAvXT9wVasS/Ie
	oOHR38ihXtffoM9dLw4mKnEZS0IcNXBAgB0umwY5BzTH9vu9XnfVg=
X-Received: by 2002:a05:600c:1554:b0:47e:dc0a:8591 with SMTP id 5b1f17b1804b1-4852cfd758dmr1893135e9.2.1773066889845;
        Mon, 09 Mar 2026 07:34:49 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:bd49:6ea8:9b67:a5eb])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-439dad97da3sm29768749f8f.12.2026.03.09.07.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 07:34:49 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 09 Mar 2026 15:34:41 +0100
Subject: [PATCH] io_uring/register: fix comment about task_no_new_privs
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-uring-nnp-comment-fix-v1-1-e7d185527142@google.com>
X-B4-Tracking: v=1; b=H4sIAIDarmkC/x2MSQqAMAwAvyI5G+gCBf2KeNA2ag7G0qoIxb9bP
 M7ATIFMiSlD3xRIdHPmQyrotgG/TbIScqgMRhmnrOrwSiwrikT0x76TnLjwgyZYOzvtidQEtY2
 Jqv6/w/i+H1DzedJnAAAA
X-Change-ID: 20260309-uring-nnp-comment-fix-2d33b61cee0a
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773066884; l=1359;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=QgwdfBmJtLUH70M5vhjZqONdVk/cg4rv3tFR0/ljb+U=;
 b=4+sekabZaaVT5qrCP74I7jUNKoc0eDeDWPQkf2nfrXpQk7GSSKrYGsclZi6rUTk6YP8pUTPyP
 vKD9LTUK0LCCog+OR1xDf3+aJ0mayIV0755J8jZC/Zk2ZX97AMC1NBa
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 3D01D23A996
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_FROM(0.00)[bounces-12593-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

The actual code is right, but the comment is the wrong way around.

Fixes: ed82f35b926b ("io_uring: allow registration of per-task restrictions")
Signed-off-by: Jann Horn <jannh@google.com>
---
 io_uring/register.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 6015a3e9ce69..3378014e51fb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -202,7 +202,7 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 		return -EPERM;
 	/*
 	 * Similar to seccomp, disallow setting a filter if task_no_new_privs
-	 * is true and we're not CAP_SYS_ADMIN.
+	 * is false and we're not CAP_SYS_ADMIN.
 	 */
 	if (!task_no_new_privs(current) &&
 	    !ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
@@ -238,7 +238,7 @@ static int io_register_bpf_filter_task(void __user *arg, unsigned int nr_args)
 
 	/*
 	 * Similar to seccomp, disallow setting a filter if task_no_new_privs
-	 * is true and we're not CAP_SYS_ADMIN.
+	 * is false and we're not CAP_SYS_ADMIN.
 	 */
 	if (!task_no_new_privs(current) &&
 	    !ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))

---
base-commit: 55a6202e7bbea301c06ad1bb0e18f7799cac383e
change-id: 20260309-uring-nnp-comment-fix-2d33b61cee0a

--  
Jann Horn <jannh@google.com>


