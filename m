Return-Path: <io-uring+bounces-12033-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIogECkIgmmCOQMAu9opvQ
	(envelope-from <io-uring+bounces-12033-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 15:37:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D412DAAD4
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 15:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F21030D1681
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 14:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA743A9613;
	Tue,  3 Feb 2026 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2AAA94f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E103A9621
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770129005; cv=none; b=Wq7RNbGAq+ScobxsFypFpY74F91+3B2qflYrAta/yVIhu2Xp+70EeAVywLuiL7+7PZtghQ1qWozyTShxEsj7DvpkDuVPmAzrYKWF9dYy+3SRPA/Wp6kKPqqfb8h4ZbwlVQUW1DSZq2qDqMZTIASu/du4ZloGbom/wKoY3UYK0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770129005; c=relaxed/simple;
	bh=UvTKWk8LbeBFHcVCJKpU20JLBXsp+tnV9NPm1OGKUwo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ZCoY9Al8McgCoP8tdANV5R96y1NHp+XaXZiZUQz1fepu8oxc01lTQAozi0KyU55Jz/zepRnG/l5OjbrFi/PuzG4SzPT8NPnhFTOPbPZ7zYOyXfOf965xicYPjKLs8cUeERQrXZ05UUQjOk0aJBkq1k8sgCLBTaMhmEBcKf3x4L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2AAA94f; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4359a316d89so4301026f8f.0
        for <io-uring@vger.kernel.org>; Tue, 03 Feb 2026 06:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770129002; x=1770733802; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehtdN2dtUUyw8t9CF8LW9obJiHb6WlF1A+WpekGmvjk=;
        b=U2AAA94ffPnCSzAikW5yA04x32mT/4Lhm3A5+o+xOc+K9spDhUGDCYtDpZMmjdnAXE
         RUcBTopbhWNOiqj0kRzDHaQouvB0y2xIBtIlW+itwdPmB6joM5Qr8Fo2u0qCVQ8h5Ort
         gg6UXCJuwbbtLf3oVpiI5o3X2VKrKDdumySLRcRGnKXXhjvq+5c8fzN+zG7hspXfupij
         uclb7juGF9sSTyScKiXLjNsD7ZtJR6iIsczy0egNElhIHYjHZcCqw/MzC7TW91X44JGs
         b1S8bu4ljJtqOgYX7OPgldm/O4IF1ps0kyDR7QI/YfCBcY9JF70cKviIDLB2/y3Xs+b5
         9ChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770129002; x=1770733802;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ehtdN2dtUUyw8t9CF8LW9obJiHb6WlF1A+WpekGmvjk=;
        b=lysv6dFsHPX0uzZ0Zhu6aIT0iLwAvLlCI6NYvH+9xCJ7E9V3EoEQpTJPt74idfCYJN
         prs/gDt8tlk95J7KsGAfB9VL2fCCyf5i/iAXnaV2C5yX9N+xlJWtCrcehXAPLhuyD0au
         VBTcIRthhPjQVMPb2u9v6avidUNB/s/YkH+lLg0wE5WDXFySLNp8v8o+AxSUzc2GAp3K
         qLMsD06b/ucsiTW2HeOf0LgWkgY3jCsbwL/YOu93A/7iqTHtVEdk/6KPRow0ao/GF01W
         oOUBZWMLqy4uF+47eo5VPX/VBLRlGGT0nkzRBXTU6YdtaWqiThKbOOVIwJyhtZSkfksJ
         B4KQ==
X-Gm-Message-State: AOJu0YyitYgU3eTSMX9PKtubA7g8KuF/c/opM9ObUlrRt7FTEc/pLBy9
	NU1lKKLJGr+PPcZi8dNDMNp81zDXZ4WCM8lgbHOMmKtICYRYLqxugPit
X-Gm-Gg: AZuq6aJecOypCNb9I1ZeugwFIFILd8m0Atq2sn7fVd0u0iE/uR6mSIKuhqWKbw/QYts
	Jp2x3/knPl96EqXx//bRzFnK2t6Wt3rH2VzkzQegaw+V9EqAJhJdovaN0von7DSxJp+GGecdLH6
	T/NKxEeILqYgaiPjNUbZmUp5J4uJof1Hzy8T/uup67vxmbz0IS8pfueISuNqwR1gWEkYKXjPgKS
	ANO77uyRx6HYUwjxHpP0N9Et+hbi5eds808VKjJjEgjcjoKqnf8A0Uapeywz3sUif5kH8BLPgzV
	1+oUaDhNbq0ZQnzTwB0Lio44834GIEyCXNunPr/0GTVhEowT4lrxuTxWdvZ4Zt4XWgBi41O1vdu
	8lg3wgnt7EueBIg9n8ArbVAXBqtaajXVd7w6FnTILDkjVX2meRtBgF+DB+t9sVmS2yu1EewjQMg
	lXzOuThAwAyGNCuWvClRZB9Zq7a/chdNB2jfn50mVf21cxw/jfZgRP/8p6pjkKId1jZyUhjiZZt
	oKX3lyVrPBr0F81UNQgp8F/pzv+k2EbDB6uJGSgCS+iG67JznCgHxMSzU2nftZaPH5YR2hwvdXW
X-Received: by 2002:a5d:5f54:0:b0:435:95c9:6895 with SMTP id ffacd0b85a97d-435f3a72dd1mr22421934f8f.18.1770129002134;
        Tue, 03 Feb 2026 06:30:02 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e1322dc7sm52615095f8f.37.2026.02.03.06.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 06:30:01 -0800 (PST)
Message-ID: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
Date: Tue, 3 Feb 2026 14:29:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-block@vger.kernel.org
Cc: io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12033-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8D412DAAD4
X-Rspamd-Action: no action

Good day everyone,

dma-buf is a powerful abstraction for managing buffers and DMA mappings,
and there is growing interest in extending it to the read/write path to
enable device-to-device transfers without bouncing data through system
memory. I was encouraged to submit it to LSF/MM/BPF as that might be
useful to mull over details and what capabilities and features people
may need.

The proposal consists of two parts. The first is a small in-kernel
framework that allows a dma-buf to be registered against a given file
and returns an object representing a DMA mapping. The actual mapping
creation is delegated to the target subsystem (e.g. NVMe). This
abstraction centralises request accounting, mapping management, dynamic
recreation, etc. The resulting mapping object is passed through the I/O
stack via a new iov_iter type.

As for the user API, a dma-buf is installed as an io_uring registered
buffer for a specific file. Once registered, the buffer can be used by
read / write io_uring requests as normal. io_uring will enforce that the
buffer is only used with "compatible files", which is for now restricted
to the target registration file, but will be expanded in the future.
Notably, io_uring is a consumer of the framework rather than a
dependency, and the infrastructure can be reused.

It took a couple of iterations on the list to get it to the current
design, v2 of the series can be looked up at [1], which implements the
infrastructure and initial wiring for NVMe. It slightly diverges from
the description above, as some of the framework bits are block specific,
and I'll be working on refining that and simplifying some of the
interfaces for v3. A good chunk of block handling is based on prior work
from Keith that was pre DMA mapping buffers [2].

Tushar was helping and mention he got good numbers for P2P transfers
compared to bouncing it via RAM. Anuj, Kanchan and Nitesh also
previously reported encouraging results for system memory backed
dma-buf for optimising IOMMU overhead, quoting Anuj:

- STRICT: before = 570 KIOPS, after = 5.01 MIOPS
- LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
- PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS

[1] https://lore.kernel.org/io-uring/cover.1763725387.git.asml.silence@gmail.com/
[2] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/
-- 
Pavel Begunkov


