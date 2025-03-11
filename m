Return-Path: <io-uring+bounces-7051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A4BCA5CDAD
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 19:18:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A5B63AE09E
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 18:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048232620C3;
	Tue, 11 Mar 2025 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OW9lWYWK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4949925C6E9;
	Tue, 11 Mar 2025 18:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741717098; cv=none; b=rvpC8SdOnM4OmS3M7ChF+jhlDZPq3vGoOD6o/LLHGv9+c/KaoFRL7IMa4rOALg6EviZB4SW5qeGyAQuiMbu2F45qN5oo3T6oTAxCRPBuuXTyTd3g6zot/EPHNL5Myxk2QHA7Hf7FBDgk9999RW7hVvi88xNgW4EyGfWTyOwTh+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741717098; c=relaxed/simple;
	bh=XUuDCw4dxRyVSzPcEVdk/CnUN1YnS5oIkKX3huz6EEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A+la/lVq31Io2DoLZWTX1FalqDDckpDKZGw4Yc0PtsJlIUBmpVgBH1SyLDWyDCCmzA2kSMLtzPnIBqi73ShmmHPezhe4CfKP+cglo+bLXWFyDDqIaohp6zEsU3lcUjBikHkcvsR8SY15+ms+osYykJhhuRDLlM+KZ6NWLBF1zBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OW9lWYWK; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso424286866b.0;
        Tue, 11 Mar 2025 11:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741717093; x=1742321893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QLhK94juuB/1rX9HBAY/4fFK+Crhu6LXq2Ne/rbwKiE=;
        b=OW9lWYWKdseN5CLiCK6RHrFq2E5XwdcFDL1o0nvXkgJKd3gc/XMqF+GJVIb4Hj6mj1
         fPgFjd26bt5sof+FbhjSJ5F78EtvpXV63vcpM/WOShBrg4xFHLR0zhenEK4Oif9J+8Jn
         UfdPcUmcDEAnguR6Z9OyUpVcYldyiDIZUAnTl5UeguaLOJXiECCbiesoIMd/u/AWJHg/
         VZuK2fEEHWkLHXtm3BsWpF1pBnpxHSS2e0bgdNy0R2dFzgcw63QqpLbr5Ehq8j4gf7GL
         Fo/oZcMUK4GnqJ6ZDDh65SSTkxY24X4YB+aXsHAT9ZWhsXkTWT6JjnO0bdSEnPnO7Wua
         P/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741717093; x=1742321893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLhK94juuB/1rX9HBAY/4fFK+Crhu6LXq2Ne/rbwKiE=;
        b=Uk+mJq54Yvp+gyjEZPokPzbnOrxdG3ECSl9Cb4d1gr8pWtzPHuYTGVrQ78Cw5xPlLE
         lVr8ioYEPRz1xXfhbzBPdyzrp0G+P0QlS/2wTBmlnlGJMe3AjYVfn93EJrSCwzS2oaXT
         3iyeAu+Dk1KAnpocxapqKXPyZtahvhFEgBHT6VP7OON2xPluoqr3S2bG7dtYiWHrIRjW
         I2HBG12okcMBW+80IdZy8HqA2OMJHbmhtxaSZMcKCh8KMSH0G2WIwR7gS4wmLoo2pFTp
         YRradBt1y5bNnYsW/LnnPqZB2RkzAXt6FIcLcFNx1UrP0/upBEBFdwOknBhVTFjTiIpa
         TdkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0sXF89GbcJX3APQj4H57oFjnEiHm3oa3fgzzFaI6RYx3OnOjhVZilUydmM5jrXw3s5DafZ64W8sw=@vger.kernel.org, AJvYcCWMG4W3jA/x0rI7tQ0css5jrfeB+tA9S0Q5JlY9RcendjqlXu3kvqvlWFrgwGVrlmmMunjfYA==@vger.kernel.org, AJvYcCXVDUNTME00cX/PvH3hvGjgqHOys6MIqNWTE1o030t5axVMGyZF4ph7bvLegWlqysTtP5+mjjokJ5IP8nwahg==@vger.kernel.org, AJvYcCXw8zgy87BMf55I9Ql9YhKbpBriLNQz6nT3f6xsOOoIughIdtvxDg+Nqhyk9TFa/RwQeIc8Wy2mutUIiaDD@vger.kernel.org
X-Gm-Message-State: AOJu0YyL6Ts3FLWJ1+Ul1nNoIl1pzvrcTF6zcgK4bmx1UyXfTYH3s5Bh
	uIUFcZzWw1h4DfHPd1SrTADZJzX9kpjvhAwMolzXMw4jeLV+cwB/
X-Gm-Gg: ASbGncvpUnI1ayhwiiW6njnobjAPl3xgy/K3En3zZh0SZiDLQVehLBDtosoYg28I+N9
	q7+2GP1U1xYjM0VVDyGBAcMHMhpEZ0Q6X1rPTh4gPjeOoDY1sUMp2kp2CLaHfydiW8GxwQnlOtJ
	35UUeRcRMyuXiR0WIgaglJRcabDk3Qukmj8uGfT2Sw8b7Z1+56JIuYlPpkbhjAAO/bq1CpxsviY
	uOkd8qx6xo1kuta6kqBaE6Q86nJ/GsHCTBXUmrgA051njmGWQzRrll00UdEoj+u0zlF3avFEEND
	QI1YpPqAP6zeMJDEMtpkVfJ+vHWaxAI81Jc3y8EM4JOnv/AWJ4n9T1Lp85qlHz+i9zUgCzs3mQ=
	=
X-Google-Smtp-Source: AGHT+IFGk1lGvnm9Z7bsrOI2oY8woHcR1k5IeQLgv2UcXcXg/tz0Sy3UxyPlFRjtinQgzUFN/frO0g==
X-Received: by 2002:a17:907:2d92:b0:ac1:fab4:a83 with SMTP id a640c23a62f3a-ac252b5a837mr2201335766b.25.1741717093290;
        Tue, 11 Mar 2025 11:18:13 -0700 (PDT)
Received: from f.. (cst-prg-86-144.cust.vodafone.cz. [46.135.86.144])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac287653cdfsm511345666b.82.2025.03.11.11.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 11:18:12 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org,
	viro@zeniv.linux.org.uk
Cc: jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	audit@vger.kernel.org,
	axboe@kernel.dk,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] fs: dodge an atomic in putname if ref == 1
Date: Tue, 11 Mar 2025 19:18:04 +0100
Message-ID: <20250311181804.1165758-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the structure is refcounted, the only consumer incrementing it is
audit and even then the atomic operation is only needed when it
interacts with io_uring.

If putname spots a count of 1, there is no legitimate way for anyone to
bump it.

If audit is disabled, the count is guaranteed to be 1, which
consistently elides the atomic for all path lookups. If audit is
enabled, it still manages to elide the last decrement.

Note the patch does not do anything to prevent audit from suffering
atomics. See [1] and [2] for a different approach.

Benchmarked on Sapphire Rapids issuing access() (ops/s):
before: 5106246
after:  5269678 (+3%)

Link 1:	https://lore.kernel.org/linux-fsdevel/20250307161155.760949-1-mjguzik@gmail.com/
Link 2: https://lore.kernel.org/linux-fsdevel/20250307164216.GI2023217@ZenIV/
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

This is an alternative to the patch I linked above.

I think the improved commit message should also cover the feedback
Christian previously shared concerning it.

This is a trivial win until the atomic issue gets resolved, I don't see
any reason to NOT include it. At the same time I don't have that much
interest arguing about it either.

That is to say, here is a different take, if you don't like it, I'm
dropping the subject.

cheers

 fs/namei.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 06765d320e7e..add90981cfcd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -275,14 +275,19 @@ EXPORT_SYMBOL(getname_kernel);
 
 void putname(struct filename *name)
 {
+	int refcnt;
+
 	if (IS_ERR_OR_NULL(name))
 		return;
 
-	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
-		return;
+	refcnt = atomic_read(&name->refcnt);
+	if (refcnt != 1) {
+		if (WARN_ON_ONCE(!refcnt))
+			return;
 
-	if (!atomic_dec_and_test(&name->refcnt))
-		return;
+		if (!atomic_dec_and_test(&name->refcnt))
+			return;
+	}
 
 	if (name->name != name->iname) {
 		__putname(name->name);
-- 
2.43.0


