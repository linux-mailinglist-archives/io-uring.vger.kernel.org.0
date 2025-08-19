Return-Path: <io-uring+bounces-9050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF594B2BBC8
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 10:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791EF3B1A67
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 08:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82620311944;
	Tue, 19 Aug 2025 08:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZoPvtJjD"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB022D24A0;
	Tue, 19 Aug 2025 08:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755591925; cv=none; b=Vk25cCd7LW73wfmpbP246w5I/S9vBvrqMy6i8XyC1PCaFcsQZ7HJUTt/2evqitNWCBEXwfoudSeVgsov1wgl1AdoNmndj0tSs78DbefxSkY57Gnl7DZ0zVqdhj3w1uk8Hz1b9TvD+BI5IOvagcKo6zmPovDchElKrFQBICNCoqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755591925; c=relaxed/simple;
	bh=vM4AbUU9xkXVoszfAxCdY1imbOBp8F1r0a9azDW6dKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U6Se9M3s0Kn2xl8IYP6zecjwKEniw+2yQDrI9a0bXJ4o0yU+Xt/kQcp618KEdnksCOLN7HwczBsEgiNP3w3rBo+uSMcpQZ1OQBOrvA3NU90J9JGlZCVpVkmQw71Fp28JQjDwQ/VzO2Rb6BVCEYalJixnS7L9i3yB1KzqqLGqo3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZoPvtJjD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gdJoJjV50vuABzCSpEKiUJnwF2KfBuIqNhY+Q1kCb3Q=; b=ZoPvtJjDR1J7+vkE93j0iNJDpN
	8tVhJ/tuwR1pOUSj2sW/C7dCeOEMb4gdLle2ZhlwPTyxmO9G6yOXfCtqvOjm+4eb/a0umzNcs3YHf
	AQUo1yJd3D/DLmRTE2vNgg6dAeLYz/gp+1rsX6yh+n8RuL5yvvOb5ig3z9EqByqlnarDR0J0hjLoE
	O/gVwnOfgPRTpDuz++PICib7WzQOTtfmfQAC1QR8jkwHG2ELtGTATVnKxbAXAiBHhs10UEujsD4ze
	WQkPXqUEbG0wqqMj1bL7vf62Qyk1j/ohttYNCCnKlFIAvvfTS6mF7X7s1R1u5/+VTnhJKR2EwBvpc
	ps4okllQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoHej-00000009nV1-09Kq;
	Tue, 19 Aug 2025 08:25:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: io_uring / dio metadata fixes
Date: Tue, 19 Aug 2025 10:24:59 +0200
Message-ID: <20250819082517.2038819-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

while trying to add XFS support for passing through metadata I ran
into a few issues with how that support is wire up for the current
block device use cases, and this fixes it.

Diffstat:
 block/fops.c       |   13 ++++++++-----
 include/linux/fs.h |    3 ++-
 io_uring/rw.c      |    3 +++
 3 files changed, 13 insertions(+), 6 deletions(-)

