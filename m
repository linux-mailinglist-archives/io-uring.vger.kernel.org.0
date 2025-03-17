Return-Path: <io-uring+bounces-7096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0488A65228
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 15:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59097176D7E
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 13:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C252459E9;
	Mon, 17 Mar 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="CpzDdST4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5292D2459DA
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219889; cv=none; b=EI6Vmni3jAiQ/J0ze5DC4mcGHbgyzKVGWL3vMVLgTvzqn9FkOBMmp+2OA3dohoD+iiAiKs1lWSd8vAXutW79nceNED9ieXSXS5+hBQBvN9jQA+e50GVKJAmJMilxJ2v5jq1VxVQO1c+6DCluqE8SvlrHZ/1JBQJO9XJh4bEmDaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219889; c=relaxed/simple;
	bh=jX0ueY9211gETMFC7G0MuImPr6rWSlX9oFF0HSj0qeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu8rnplZfV5yIQdh2F7nfbV75czI9+UAkJPgGT3ZO43Q7/2cqK+njrLSuNvhx1r+jxB3FYnIWW0e5Biybgn6CBw3TmSHg7OtNFr/IVCEhKbuBRmd3giAc3o1LTGJA5S2Sc3tHVP0HEp6DFjgYF477iDyE87fJLgZKnQ0AdUlec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=CpzDdST4; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223fd89d036so84956635ad.1
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 06:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742219887; x=1742824687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCFknnsao+MA3rkiA5nb/VuBAcmMICvzxTPutU19C0o=;
        b=CpzDdST4SUHXX63D528pN/pT8+g3o8kiuU3UkTTWcwsbL19Pid2fyrglxdER4bkTwU
         3HJ9pwi5C+5+vF44ZCrnyyXwtjNagIZFva25cI+tWpf/W59w6G6jzJLvS2+79yTTWP0M
         2em89jC/qYQZRpfpGGyl9pvWnfvV+xrTuCiVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742219887; x=1742824687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCFknnsao+MA3rkiA5nb/VuBAcmMICvzxTPutU19C0o=;
        b=kmETuGxjU+cVRuM3jN7H9CY3dZpX4mJt5yW1N8BvDZfgh/d8VpCmXET4EbDX6o0gWg
         9aqnFWRqWUxe0kmJS46Yun1L/lbprGtAPt4nwFuSj6NKth2Xjjxk3sAlwdsTwZmrXp/m
         k96V5dJfgO6rHeD7f5ZqfKLPV8YTyHTQi0Gk0RHtbot79ms7wcLN3RwL7z5UkBffjJzR
         VfMvQ2DxzjB9kKNNim29N69ZNU2C6sBSqVInuKANiDX1XPaxFLOHGUPyjiV8ygZqICHR
         1UdVcWW0iZXMqZOI9NIbidOu5A6CnhsLE520vfvuOPukVWW8oAbF72pUuvBpiEf56XRW
         4yvA==
X-Forwarded-Encrypted: i=1; AJvYcCWmUJiT/AY7/KGemnxZjLF5v2qeilzmSVqRrDOjaFSVDNO/26CvWL9m/FUwfmJDzecv8LhK0odTGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKiU+R0Nq5BctJAveuFwIPA7ydhP/H4PzgzqyS2eKmm9arkcuL
	vkUbl58RZ32s44BkPpOakINmdzi9LLWZLuEdXrgn2UNNpu99haKbxdBf6KPsrqY=
X-Gm-Gg: ASbGncu9+oXt6Q7TKuzq0n9ohHyfO0EYJ9xTZkexv9KwGey3U9jzGR+vdOCWkZSC0Gg
	1BWx5CUDZLOEuOjdVjWlgukoGRPdxLj8TznjfKbcFt4H41SOQg6h4HVSDtOeYp23Be+GPD5OeP5
	eHfN4QvQ0xUO8IABckt9PMd9A/r/qf0Ax0jIEZwml+/9kL19I7L07JdW1kgnd+Pb/b9XYiOFPbA
	1I+wE/8tiTAym93hQFf7RtHhYfsJWFf8BgrS2UHKJmIudRwByn5uTXnjkF46LB4pkfT7XffXSA+
	hyU9t18JNPpGwPkqwwMD6dPMaLl6D+9aPxYKoGCF5sNB+ftl6mNdfTB10IzG5JOR/u9CiwgxZ79
	V0F3u
X-Google-Smtp-Source: AGHT+IELSRI9QIZeeFAktb+zISbFeOiwkhBMlafTPTduJwqWCwWpj5FYPH9pfrHw+RSrrQDy4i+60Q==
X-Received: by 2002:a17:90a:fc4f:b0:2fa:15ab:4de7 with SMTP id 98e67ed59e1d1-30151ce15a6mr18431695a91.12.1742219887603;
        Mon, 17 Mar 2025 06:58:07 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30153b99508sm5993742a91.39.2025.03.17.06.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 06:58:07 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v4 5/5] btrfs: ioctl: don't free iov when -EAGAIN in uring encoded read
Date: Mon, 17 Mar 2025 13:57:42 +0000
Message-ID: <20250317135742.4331-6-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317135742.4331-1-sidong.yang@furiosa.ai>
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes a bug on encoded_read. In btrfs_uring_encoded_read(),
btrfs_encoded_read could return -EAGAIN when receiving requests concurrently.
And data->iov goes to out_free and it freed and return -EAGAIN. io-uring
subsystem would call it again and it doesn't reset data. And data->iov
freed and iov_iter reference it. iov_iter would be used in
btrfs_uring_read_finished() and could be raise memory bug.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a7b52fd99059..02fa8dd1a3ce 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4922,6 +4922,9 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
+
+	if (ret == -EAGAIN)
+		goto out_acct;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 
-- 
2.43.0


