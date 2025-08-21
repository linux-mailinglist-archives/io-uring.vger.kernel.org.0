Return-Path: <io-uring+bounces-9149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D79BB2EB80
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 241217278D0
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE502D3ED7;
	Thu, 21 Aug 2025 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYXHujI8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3EA1D435F
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755744996; cv=none; b=NJ0AbEERDZpupkk0Zy1LpsIV91euCtu2sBHSRwa761fj71nLOQy/GqTbo2pmImO318XcvnAB7+uLuuwhtzbLjOjQhVKXaIBcSZ1R1gA/pK2cCF+bwucGi7u3pwOdqKHSELBnEICl8xxI3GIs+uCpYIvUzYNa7sTGjmNx/qdn7Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755744996; c=relaxed/simple;
	bh=balfMEORisG0GrrKqsodEt+jiqQAngx3v2OR69BFcPY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gcT8VRywGrQLXqWejtcvcjXV85HH+G/SN5TEbVYuYsGpBOPQ1bdjx4Je/dcHi0/UAXbbzXDO19o4icvTWxMt932qK2te86TZL9xqPhtR1GygRGh8pEVUKx/hMGbgUm9b5/4z1NW2dXUWPrdSn4s0BD1OLYunSlr7jULjOhuGajE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYXHujI8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244581ce13aso12698685ad.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755744994; x=1756349794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XBaK+uDkb1FKWMnsKSy6ZhbJaoQabX0cbuYGiNdtzlM=;
        b=LYXHujI87+IlJ7ShNwMEIaWA0S5GM6sbWmOZVMdNLwdd69wHTCNTDYaUfcZoYfG/+I
         4NuAdvw1U7ajbcrTPlFmLJP++Vr5RSbJAxc1jE7sYLhEjy0ZrJW5eqysbKXCmmFbBFku
         T3Xw6ZSgoyZeWIMONesdFamrUimkHv//Xy0agQSaEQWw5Dsr/BdV0C6DxJp/SABnQx7y
         LMOJBS4Sppav0lP+BVhWsBXy6a2QX04B6DvN1Rp6r86Z322MCqbs2VynjtxFHaN2fdW5
         BLAXDBzQmm8GHhx3GozwGQH7Mbzu4Ss3HidfYi2MM9RvFHcdsiYisTSt+W3kFSdN5hip
         YYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755744994; x=1756349794;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XBaK+uDkb1FKWMnsKSy6ZhbJaoQabX0cbuYGiNdtzlM=;
        b=q8Y0kA1029mEL8iq8DEjHsjC5T/Go2tHHMxkCQ5vla7WTAE+rw3mY1MimbQKCMy7gF
         u9l3GtIb5682d0chM77fopJVuXqDh4zE9rdqohlkphvhI6Evcr4H6sy4PLrfWDU4yYOQ
         LKP0KUlyEGvPUWvyfo3/sVR8gx7mCLuCwwk+4QoRBTBacnKpPB8FKr6xYhbRAYMBjgwb
         9u/1jHj9s8goXynP+DsNcWOdpob3ay1YM6ELZeunERjeFH0Zb1vgTXcWSXcFiXZ5e3aB
         H6Ma6UBFwXJXCcIyUaPSCZDLcRoqAIZ5NIAtjsUMuY15tjkRQ6w+pOpi8icX/ZlixrDR
         srIA==
X-Forwarded-Encrypted: i=1; AJvYcCX7jwJ2z70Rq5s5lMJxGUFwFhbgi7nZ7u/4a93YhS3hfbkhs0UwMBmRzAmZx+61dhFNM8atfFIWQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGHVrqAYNmzN4ou1eTr5QgNAmErACOqZO7qULNTKdKaA8j+GBe
	tFQhx9kmuB1NTPC4BaG+Ddypef5hlB9yTwfOGcR1znx7ECjH++g9XDn7tGOGKR3tHDkrK2nfkr9
	lPsXDzmN1KYJKpeOQTGarlNgMeg==
X-Google-Smtp-Source: AGHT+IHOUOftlFA6gwO5touzHJxQk7/q1lypr8Q4vbHBqJ26hjGPhbxSN2SE73bXv0muunHuQFwlQukp1KrVN5ncmw==
X-Received: from plbkx11.prod.google.com ([2002:a17:902:f94b:b0:240:3ec9:aa82])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2f85:b0:242:cf0b:66cd with SMTP id d9443c01a7336-245fed69268mr14788835ad.34.1755744994361;
 Wed, 20 Aug 2025 19:56:34 -0700 (PDT)
Date: Thu, 21 Aug 2025 02:56:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821025620.552728-1-almasrymina@google.com>
Subject: [PATCH RFC net-next v1] net: Add maintainer entry for netmem & friends
From: Mina Almasry <almasrymina@google.com>
To: linux-kernel@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, kuba@kernel.org, asml.silence@gmail.com, 
	sdf@fomichev.me, byungchul@sk.com, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

There is some needless friction with regards to whether netmem_ref,
net_iov, and memory provider patches being CC'd to netdev or not. Add
clear policy and put it in the MAINTAINERS file so get_maintainer.pl
does the right thing by default.

All changes to current and future memory providers should be CC'd to
netdev. The devmem memory provider happens to be under net so is
covered by 'NETWORKING [GENERAL]' as-is. The io_uring memory provider
happens to be outside of net/ though, so add an explicit file entry
for that.

Note that the memory provider changes need _not_ be merged through net
or net-next, but the changes should be CC'd to netdev. Target the
appropriate tree using the [PATCH ...] prefix.

All changes using or modifying netmem_ref or struct net_iov should also
be sent to netdev, so add a content regex for that. Patches modifying
the netmem_ref or net_iov infra should also target net or net-next
([PATCH net] or [PATCH net-next]). This is already the convention.

Note that no maintainers or reviewers are dedicated to this entry.
We don't presume to overburden existing maintainers or add new ones; let
the maintainers nominate folks whenever they feel appropriate. But make
sure changes are sent to the correct lists.

Tested by creating a couple of trivial changes in io_uring/zcrx.[h|c]
and adding netmem_ref and net_iov in other subsystems, and looking at
the get_maintainer.pl results.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

Cc: kuba@kernel.org
Cc: asml.silence@gmail.com
Cc: sdf@fomichev.me
Cc: byungchul@sk.com
Cc: io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4dcce7a5894b..22c50aeefaa5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17853,6 +17853,17 @@ F:	include/uapi/linux/unix_diag.h
 F:	net/unix/
 F:	tools/testing/selftests/net/af_unix/
 
+NETWORKING [NETMEM, NET_IOV & MEMORY PROVIDERS]
+L:	netdev@vger.kernel.org
+S:	Maintained
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
+B:	mailto:netdev@vger.kernel.org
+P:	Documentation/process/maintainer-netdev.rst
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
+F:	io_uring/zcrx.*
+K:	\bnet(mem_ref|_iov)\b
+
 NETXEN (1/10) GbE SUPPORT
 M:	Manish Chopra <manishc@marvell.com>
 M:	Rahul Verma <rahulv@marvell.com>

base-commit: 62a2b3502573091dc5de3f9acd9e47f4b5aac9a1
-- 
2.51.0.rc1.193.gad69d77794-goog


