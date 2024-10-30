Return-Path: <io-uring+bounces-4219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD229B6A3D
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4F71C215FC
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E624A21A718;
	Wed, 30 Oct 2024 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rQtHU/2V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D9216DFF
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307535; cv=none; b=RmESpoEICpNUCpEdmktP+aCxP/aF1hwYRVxZCdlS5K4hiZ1UNOGieW+iyuvwoJX5iLnAteKBcNSEEEBhUde84uXvG80i0WkfmlBEfgw8EpCUYV9gXFq26bUGIi7PhiN1XOwa/Mbxb0Zjf76BITWnGTuxJgaxhgwGdj6w7BSgTN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307535; c=relaxed/simple;
	bh=cNDsXsuTEXeaSfa9Bk5LLs1H6160Pp1SXmeg/kVIzr0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=KqDlJd/1862kuiUlohOM0sBX+MKoiiP8NoIH4OkiYUzeOnECWDOe7Eph5UQiJEWdHu7L3JtfJ1xSpT/jKZeXi97B4GcrsBVLXyYXc3Ly6WFQ17rqr1hodM1okIop85TQppcGoa/H5qsvDgKBw5hA/JeVFavdVF/MC3KiArBRYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rQtHU/2V; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83b430a4cfdso123293139f.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 09:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730307532; x=1730912332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7zjvxfo4RA9wtSmDn7Cj6QXedm/GWH9XYbFN+kjhzg=;
        b=rQtHU/2V1sdHeENpwFt6UAlxgu85e8mQ+fW2rKuxHdKmtjUHcfibIf0AWiM0Pmt6Gf
         m8e/sziW7JktdfcKqg4Rj58KrtnTAKqnFgW62/ul2+1vs6C5rxQwXjW+/etSMFB6m43P
         kIn4ENEknpp56PtN67BmfABHPFWgDTDzcQLHJxJf6bqbHXR2OCQY/5lCQvIGWMzpV8dG
         ouu4s+NxfhjU+VxHjVw9ET+yyHkclkgRiYxJ18gueQetIABkl8dbYjiZ4Pe2SvIjeOqy
         s1QZbxKIBHGcAOXNUwwiXQIHJEHuZrGFQKtlxyBQPB71JtxShcPbBF+vZPeGVmRllEKr
         gy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730307532; x=1730912332;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G7zjvxfo4RA9wtSmDn7Cj6QXedm/GWH9XYbFN+kjhzg=;
        b=DjRBm5wOQYy+g7L42aK9SV0u7CvJ3U+sk/jszzMUYNzbgUCCoGHK5zOiLLQsgVD8Hp
         g8FOONLu6TLu2cwJCEHvkcOxugtUe83rk0gw7aKI9yJLVHcsylCg0zzDHzmCLCDpifhF
         ymGiVmXa0nedQO2el9+eJeXCXTd/3SKOYrnYeyMki8SQUGDNRBRfOjbEVsw8+EXBqZyp
         ZreSGr6TTp6y0cREi+MQpLRrhEmEri2F7ZAH8fzU3teM3cgC1gKWnkgrIMTMcXIvmyFR
         w5p9YMEa4JCKrpi04M6M/Akx34bZ/TYM1/09DmUrri71FT+jliudqUaUqQLrrpuBWqWx
         s6BQ==
X-Gm-Message-State: AOJu0Yxs1MKfMyiWv0vtZ36drKgIHsbz5X6U2gYltzVoaPnC09aPIK+v
	WqedPnJHjt5ibYAcRyBMmi1RPo4wYj2VlY6Zk2SB8fqBKJFBn3p984lugHJ0Gpz4X5Z8D4+xz8p
	YySc=
X-Google-Smtp-Source: AGHT+IELRrk6g5S2+JEQ6OQQcI6xxhfyw7XRWQMf1CMhg1m1l5wW1TTDv/2E5OqO6r+6GCA9xMewkQ==
X-Received: by 2002:a05:6602:3413:b0:83a:b235:2d74 with SMTP id ca18e2360f4ac-83b1c40d531mr1659636239f.7.1730307531783;
        Wed, 30 Oct 2024 09:58:51 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b137c9797sm251527039f.10.2024.10.30.09.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 09:58:51 -0700 (PDT)
Message-ID: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
Date: Wed, 30 Oct 2024 10:58:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC] io_uring/rsrc: add last-lookup cache hit to
 io_rsrc_node_lookup()
Cc: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This avoids array_index_nospec() for repeated lookups on the same node,
which can be quite common (and costly). If a cached node is removed from
the given table, it'll get cleared in the cache as well.
io_reset_rsrc_node() takes care of that, which is used in the spots
that's replacing a node.

Note: need to double check this is 100% safe wrt speculation, but I
believe it should be as we're not using the passed in value to index
any arrays (directly).

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Sending this out as an RFC, as array_index_nospec() can cause stalls for
frequent lookups. For buffers, it's not unusual to have larger regions
registered, which means hitting the same resource node lookup all the
time.

At the same time, I'm not 100% certain on the sanity of this. Before
you'd always do:

index = array_index_nospec(index, max_nr);
node = some_table[index];

and now you can do:

if (index == last_index)
	return last_node;
last_node = some_table[array_index_nospec(index, max_nr)];
last_index = index;
return last_node;

which _seems_ like it should be safe as no array indexing occurs. Hence
the Jann CC :-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 77fd508d043a..c283179b0c89 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -57,6 +57,8 @@ struct io_wq_work {
 
 struct io_rsrc_data {
 	unsigned int			nr;
+	unsigned int			last_index;
+	struct io_rsrc_node		*last_node;
 	struct io_rsrc_node		**nodes;
 };
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9829c51105ed..413d003bc5d7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -139,6 +139,8 @@ __cold void io_rsrc_data_free(struct io_rsrc_data *data)
 		if (data->nodes[data->nr])
 			io_put_rsrc_node(data->nodes[data->nr]);
 	}
+	data->last_node = NULL;
+	data->last_index = -1U;
 	kvfree(data->nodes);
 	data->nodes = NULL;
 	data->nr = 0;
@@ -150,6 +152,7 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
 					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (data->nodes) {
 		data->nr = nr;
+		data->last_index = -1U;
 		return 0;
 	}
 	return -ENOMEM;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a40fad783a69..e2795daa877d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -70,8 +70,16 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
 						       int index)
 {
-	if (index < data->nr)
-		return data->nodes[array_index_nospec(index, data->nr)];
+	if (index < data->nr) {
+		if (index != data->last_index) {
+			index = array_index_nospec(index, data->nr);
+			if (data->nodes[index]) {
+				data->last_index = index;
+				data->last_node = data->nodes[index];
+			}
+		}
+		return data->last_node;
+	}
 	return NULL;
 }
 
@@ -85,8 +93,14 @@ static inline bool io_reset_rsrc_node(struct io_rsrc_data *data, int index)
 {
 	struct io_rsrc_node *node = data->nodes[index];
 
-	if (!node)
+	if (!node) {
+		WARN_ON_ONCE(index == data->last_index);
 		return false;
+	}
+	if (index == data->last_index) {
+		data->last_node = NULL;
+		data->last_index = -1U;
+	}
 	io_put_rsrc_node(node);
 	data->nodes[index] = NULL;
 	return true;

-- 
Jens Axboe


