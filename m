Return-Path: <io-uring+bounces-11853-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDDaNmn7b2mUUgAAu9opvQ
	(envelope-from <io-uring+bounces-11853-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 23:02:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 774DF4CABE
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 23:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ECAD7925C99
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E483A961B;
	Tue, 20 Jan 2026 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bq6H3T9v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16683A4F5B
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768943519; cv=none; b=K7aJGr9A1lZHJGwZQDRZKh3ZzUR+afAkG8wipTssgE3qfkdaRGZ6i4z6DVMJr3rU22+3iByJ9wh+rPpEYs6kZH4lgCJvRZZ9WXJyWArIWcSFskuYkQna0xm6AXj++sXKkx6w3kZm/rQvTNKNgLR0a/W1seGBTIOPwKmRKsVkX7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768943519; c=relaxed/simple;
	bh=jNnAzixR0AA4xDtUQKUBOp8cIS7+rKNEEiu23NuIWU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p9W9oFVSulLREKYTRjyTvmgUXR8lu6lh4ilscgixtF/11tYhvjqh41j9IC2mFm4oMbqkmuDZuRsyisjOSh8Zub44nsb5s7CmAnfv1H6NiKrUPhogUAGF4FYcrQuOrqI9DdxgB4CAcPwUpzdnSZrJyLFcO3jTALhX8/rZsRDmBRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bq6H3T9v; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4801c2fae63so38103685e9.2
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 13:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768943515; x=1769548315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fKpbQ5kYdCHW7aYxQQP0Ro5fkrvmbtT5F4JqDqvJI28=;
        b=bq6H3T9v5FAWuHRpe2flEcRkc0EAJ3qvJPz+ADcNSTA3r7194At/jwRJ04NcndLhO+
         qjlW1GZ42RcGMMwx+U+3pU98uX50Ii8yyHYKlhlFkXLDlFIA4OC9TdZRP41MlzJSlYYr
         lodPV3CFWWhlUfPYefmZaIHYCctBqgAxdXvAfx8f60RVct8t62eA/qS6Xdmq884+KjRK
         UT/oa++90pe+Ir28pqRsoaT9oRghIgEKCjiZm6+2+byn2E7Ljzvx2vD3xazy/ofLS99h
         YCk8fBR+4xYTdxwI3c8VUOBtZq2Vnmorr2DZ0zKa7IXUnFO9rDmX/5QWudo+e208pCQV
         XOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768943515; x=1769548315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fKpbQ5kYdCHW7aYxQQP0Ro5fkrvmbtT5F4JqDqvJI28=;
        b=AdM8aXokkXKei34XSP5kvYTQFsN9JEwfx30kDV7bg7ORQy7QAeeWLqzr97Lb7zoy9q
         pn9id4ZNCr7CbC+3OYSwvy+vZggH2oF4+E7KNi4qujY9J8Uk+0aYFQ3LiO3p2kI3cX3S
         I2ucj41HJcC/t99KmGw73CRYtpuX+LxbYW9C+3xG+1Q/MqEpUfaH/yhTwbLm0JDVje8N
         cmzXqDkJSCHleY+toFYQoHiv3nUeHChXQs9XQLlltHjEeYSay4WamTjL/UXLLR0ZZJM+
         dACx7EQK0tCo/2WMSMuiLIJ20YF/pZ1wwF4BLIdH86vvBPsbgtfRDBFjxDA2faOgnAlu
         HuZQ==
X-Gm-Message-State: AOJu0YzaIKpg5Rn2pcVFMMUnRIm6o3RiR3Yg6uAp6E+fmeEuJsV2cpOv
	VBWQtAESe9h8+7GMr9GCLralLVcEmPqsRi+cj+yqz1uOj7mkSfjniPlsqvXSOw==
X-Gm-Gg: AY/fxX6+B2V5XCp4sbr7Zk1N67Dei4m08lq23GxYb04vSYpwqIgi+y+QAR469Qhspm+
	AOsQFZjJYV5cVma7N4vXBRMkrxeAZDG2Y+g3Qul5oumuHFCLNOk+JcLRDum1ineoupLLzI+DWr9
	ZRbcr/OXjG2Vq5ElC2dib+Vn3tqJpQxxiM628NHN63qtJVpai29GgdEc32fac+/1R5BWu4AfLXD
	QoqybmDEwEuhkBe+6tsaPHFc2ys7lJsAD0WBA+XY5+vrEzjMatyyhAHbMDmkLBhq2wHijVQBH4v
	6tzbNp2dsb1TwmtoIfbeNfoptIeHttzZC0TJzfRX7gsDkg2rstcxQaU98Yy1vGwSf49Gcsg3dXF
	qzKT0jkvbPKNoqOKK5HrDXJsTucO+4mBs/gYuMbQQEaROEylVq0j0P0HYbXW/EJokh1cZ39YlQ6
	5OfCXQgG8a7+Ukg3e2Zc3BOSwfhopxjtikwk7nPjvB7F4zrpTcqJCYh4weYRJyDuuiTJkjlkqBe
	wwn1MWN8vKxgSj9pXyQKrjwBuA=
X-Received: by 2002:a05:600c:4ec7:b0:477:7af8:c88b with SMTP id 5b1f17b1804b1-4801e30b6f4mr173542645e9.11.1768943515449;
        Tue, 20 Jan 2026 13:11:55 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48042b6a3e2sm1750445e9.1.2026.01.20.13.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 13:11:54 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 0/2] mini-liburing updates
Date: Tue, 20 Jan 2026 21:11:43 +0000
Message-ID: <cover.1768942757.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11853-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 774DF4CABE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Update mini-liburing with NO_SQARRAY and io_uring_queue_init_params()
support. Sending these separately to get rid of dependencies, but
they're also nice to have while writing selftests.

Pavel Begunkov (2):
  selftests/io_uring: add io_uring_queue_init_params
  selftests/io_uring: support NO_SQARRAY in miniliburing

 tools/include/io_uring/mini_liburing.h | 59 +++++++++++++++++++-------
 1 file changed, 44 insertions(+), 15 deletions(-)

-- 
2.52.0


