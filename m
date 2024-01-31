Return-Path: <io-uring+bounces-509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE01B844818
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 20:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 859BF286233
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 19:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A2D38DED;
	Wed, 31 Jan 2024 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="X86MzKWc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E7F9F4
	for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706729881; cv=none; b=U1LoDB7KTh5UTjUouWkCy+9lecToyM3UzXi9xO7ou89NbHz2bVOFejJ3h6tTVM8hxmlw4D6/+kDuyWiINk502Ep0xnzVB7Rk11fKqe2nj6NmwhH19RhbeAk5/TBvCszYleLDoLOH5mr+ZhTDjdYoap7Nl/v2+olJE3iLY32gnuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706729881; c=relaxed/simple;
	bh=X2wkaPVviVqyqbfXPgKT/+3E+kdkplDPl2MPVaNo4rE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=abJc4PkxVXsWsewAAKrRP7b5/dRo/ZNeaGS40Wgx4996MavnEj8Ha2179p/+H0z3uqHeVWZZwWv6+OAf4TnKcZspDDXUMROl9XwBeCAEFle7l8K9lnI56oSS+RzR7GrT6oYdLuLE2ZaFrUjLvZJYzkbBsWP0+dea/we/dyHbjvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=X86MzKWc; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6dde65d585bso69897b3a.0
        for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 11:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1706729879; x=1707334679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=daqNwhof1b/mE+3RQX194HBSH/1C665llJWyLuttWcw=;
        b=X86MzKWczOaCXpb1B74wPhMCX62IS9B9uVSpdKOgFtSpVehfSdfKHtZ9AorKYfV1Le
         RNiBeZaYxQr/QyQIMHrrPU/MEKiNogHK5/V7tnA4ynBSrtF2RqviuL5WZgY2IAP4O4J2
         feypLTeQC5X81qS4DL8ikESzXJUIe7m6kXdfib2QNK2RKeUf5g1HW08UNMTDSQHxvleT
         w3scK+6vaYkND9TlsTiMnRLoQEMfT21gxoJxRSSsr4354CgLFUsx4T9fFWkatmjQrnzp
         CLioZSEJxLP/06E+dPdBtAb45HGd4anlHmXPiYEnBozyWYYZ/2l24WQVgs3utY2950yP
         nl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706729879; x=1707334679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daqNwhof1b/mE+3RQX194HBSH/1C665llJWyLuttWcw=;
        b=WeBzfMUdTQII//484kw0yDZ02VzI345t8QhsdnIGmIDW5I7Q+iq1knjL7yRvnSJxwZ
         qTGzinhOa2mYzhTNXB88KRB4ie3NFp7PmtBZLUwTsPZfbr9OjiKEHHHnbenbIicESDja
         E9cOvRfunP3k9gs3G6ZZIK7Cg/pqWDcq2t4b2VrUE6YlNsiNB4XT+nk/SIMIIr2sPWnn
         /IquOvObULhiHme0gyZgg430R2yxLCj7QhsE7o4owLhlgX9OqbGTHtA90DXdsdhdUbQb
         yaAzPmE8iJDjNNpZ4regcxfbJnQKniZ1r9PvMQJ0QyZgYxMAg4yc4yNopoI6E097eNs0
         PM1A==
X-Gm-Message-State: AOJu0YxNE0SVIP09nZbJpXjfk2rThVlijtYgti831T4GU84pGXqNLaJn
	UAa0BgLCxPPakIfSQIQ9v9tNnmBsJ8DvpTIeq2adNko+KKeN4C/02dgLsqultEhURBmMSiduHSI
	N
X-Google-Smtp-Source: AGHT+IHUZqTbNAQBojwLuMcRlAXcH9F3+gbvbHW0xLxrfRAsuVi+Pzx3g+jOGFVt0wlitWe/aCAnWw==
X-Received: by 2002:a05:6a21:3511:b0:19c:b3e7:fe39 with SMTP id zc17-20020a056a21351100b0019cb3e7fe39mr3181863pzb.0.1706729879015;
        Wed, 31 Jan 2024 11:37:59 -0800 (PST)
Received: from localhost (fwdproxy-prn-018.fbsv.net. [2a03:2880:ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id mo14-20020a1709030a8e00b001d8f4c531a4sm5122085plb.70.2024.01.31.11.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 11:37:58 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1] Add compatibility check for idtype_t
Date: Wed, 31 Jan 2024 11:37:50 -0800
Message-Id: <20240131193750.3440432-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_prep_waitid() requires idtype_t, which is not always defined on
all platforms.

Add a check for the presence of idtype_t during configure, and if not
found then add a definition in compat.h.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 configure | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/configure b/configure
index 9d29e20..052920d 100755
--- a/configure
+++ b/configure
@@ -414,6 +414,22 @@ if compile_prog "" "" "futexv"; then
 fi
 print_config "futex waitv support" "$futexv"
 
+##########################################
+# Check idtype_t support
+has_idtype_t="no"
+cat > $TMPC << EOF
+#include <sys/wait.h>
+int main(void)
+{
+  idtype_t v;
+  return 0;
+}
+EOF
+if compile_prog "" "" "idtype_t"; then
+  has_idtype_t="yes"
+fi
+print_config "has_idtype_t" "$has_idtype_t"
+
 #############################################################################
 liburing_nolibc="no"
 if test "$use_libc" != "yes"; then
@@ -590,6 +606,17 @@ struct futex_waitv {
 	uint32_t	__reserved;
 };
 
+EOF
+fi
+
+if test "$has_idtype_t" != "yes"; then
+cat >> $compat_h << EOF
+typedef enum
+{
+  P_ALL,		/* Wait for any child.  */
+  P_PID,		/* Wait for specified process.  */
+  P_PGID		/* Wait for members of process group.  */
+} idtype_t;
 EOF
 fi
 cat >> $compat_h << EOF
-- 
2.39.3


