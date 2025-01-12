Return-Path: <io-uring+bounces-5836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EDAA0AB69
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 19:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 340BD165F00
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 18:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6403033DF;
	Sun, 12 Jan 2025 18:17:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAACC182
	for <io-uring@vger.kernel.org>; Sun, 12 Jan 2025 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736705840; cv=none; b=OrzM05fiPiDKeTJ8lmjmJpNuGJZxDhrA7dQ9iMmOTMRZ48OanaW6jxOys7TO6FnWC9Mx7tTLoJneNnsQ3p29xPAU6lnYhm3GanL0vDWk8VM2og6ujW7z6jKo/vgSJZzJd3ZBey/Ry2H7+hBrctcXNAsVBcRZCBji1soKc2OiOGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736705840; c=relaxed/simple;
	bh=qk9Xhi7+FLV1rRoCwWlpTU6mev0s/1M9Iu6zHeKh2Sw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=K+LTrJpL0h2IvsL0LEsGMSY4K8nYYWdlAm3RexUlne6r3EUvqO1FXEWtpIf7oinZZZpRw+razxN9h3tWZAl5diDZTGCT1a0dI9b2fyljPGvLxZcf9b2ZsOeywStVsOXF6hTym97ud7V8drh6ys8ZJegxGxTRMaWX81MoTgT9k0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org; spf=pass smtp.mailfrom=holtmann.org; arc=none smtp.client-ip=212.227.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holtmann.org
Received: from fedora.. (p4fefcdc5.dip0.t-ipconnect.de [79.239.205.197])
	by mail.holtmann.org (Postfix) with ESMTPSA id A98FACECF7
	for <io-uring@vger.kernel.org>; Sun, 12 Jan 2025 19:08:33 +0100 (CET)
From: Marcel Holtmann <marcel@holtmann.org>
To: io-uring@vger.kernel.org
Subject: [PATCH liburing] examples/io_uring-test: Fix memory leak
Date: Sun, 12 Jan 2025 19:08:30 +0100
Message-ID: <20250112180831.18612-1-marcel@holtmann.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iovecs structure is leaking even for the succesful case and since
everything else gets cleaned up before exit, just free the iovecs
allocated memory as well.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 examples/io_uring-test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/examples/io_uring-test.c b/examples/io_uring-test.c
index d3fcc9ef2f5d..79574636a0d7 100644
--- a/examples/io_uring-test.c
+++ b/examples/io_uring-test.c
@@ -108,5 +108,8 @@ int main(int argc, char *argv[])
 						(unsigned long) fsize);
 	close(fd);
 	io_uring_queue_exit(&ring);
+	for (i = 0; i < QD; i++)
+		free(iovecs[i].iov_base);
+	free(iovecs);
 	return 0;
 }
-- 
2.47.1


