Return-Path: <io-uring+bounces-12995-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OP6UDMhf1mkfEwgAu9opvQ
	(envelope-from <io-uring+bounces-12995-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:01:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5673BD523
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E3654302C5CC
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68243D3336;
	Wed,  8 Apr 2026 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="BLapcAMZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAA3D3328
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656849; cv=none; b=OGfiZR6gziqaiNlkVB56Ej8SQY2tidoY6tTbNTDh+HO7oLzfnZUYJrZBEpDqt6SZBcFhs4zrMJpkCHv10J5b4YSIJTO+cIeYgbZrN+/hEbJ7beffYTXXnjC+8D3dAr1xkMLEmkJ+jyS+WmiCqbyNm9BsKsuuyLDVlXI2NzGINo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656849; c=relaxed/simple;
	bh=9tIRZ7wtaK7vVXlVitnVin2aqh2a4oFAewRMzOPu3io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHzXUXNM6juY9TWb0vL4ilPIH308gqkqChJbH6Dd4UGi70RDGlh76xRjXvfgUUrLNmHVaa0bfGxHsh3+s25o2JsrBfVOnZOzjWhDADxf36CwqUGbxHhSD2nFlB6mV6EB2+hAV+8OmRfB+YZ4y8t6lPcv6ZSG39rVU3p5idal+h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=BLapcAMZ; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c76b9efc299so2643823a12.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775656848; x=1776261648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z26SDW5ZIR+r/lzeAq39TL8dqU+dlFU+cqs8ZAl7ag4=;
        b=BLapcAMZd/6hlxtqClOfZnV9LMlU2G2gvv2UC8HuQWQ6BVk5aBVKpzHLaQ56+s/Xvs
         ERK8jN4PQhHc1GKcJHdRGeGma9D4Zesd0CVOwc2q69SSvIOA+PTSWdjOArd+5vW9dH5Y
         l/wQLO4R7ejwPWGO5HOqbycAX8wPMKKcJ5xjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775656848; x=1776261648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z26SDW5ZIR+r/lzeAq39TL8dqU+dlFU+cqs8ZAl7ag4=;
        b=be8ng8U3ze5i+EBa8fd7NHAw0JuJYD7Fym8KQmorBnV/KqsDpntR20UcLMZu2tKkMm
         nMvYFrCTGWaEGOtH5sSP3bjhWztNV8roatALSYLS6jyY6q5NezgAlrnGQE1naKlHmTfH
         3JxLoGt7CPkYE+ap/woBemznud+WZDA1ltyh/medG4D2DBuDC+HhQGxM40j0Ow1kxEh+
         INmosmYlz8VkajMx9q9Y09g63vyYw6AdxIHqUHkOuGvBxldC0O/5I1ADAG29oFyMuxxR
         Fi5EBkenzjxUWD7kmE5aodhz7pAdwNkzwUI3vfGZG26k31P1OE16TsDwJ2wwC7lIGKfi
         E6hQ==
X-Forwarded-Encrypted: i=1; AJvYcCV08btMUNlN53tc0TQFAaBc+SN7BBGXvp3ubx/7qwyBEN9FHxeJ4+WAr9omQvZLD1nHb2cEyZQetg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXnk3LxtpIv6NhZdJelDJPU4UBF1IEdFHjukajqVXWyVx78+gS
	UvyLccYCxETdQbChoGuA1AbkIUPVQ8iCjhsVhPIi1EL3fDKmHdxzl9n+krVFB9M0zlU=
X-Gm-Gg: AeBDievK1khs8MGxYpillXEFaJDcTinTac+BqRaN1SrQpdr/DeNMIzhuY8Q2uLqQe5e
	F3s53bDOPnVGPmAY5Hr+Rrb6sv5Mtxq8yJu2LQ6ZuwUT5NSoVZ+sz8W2n5ssaX4iIk9SpQAvwBQ
	hglxMCHrrjoR19Z/4/uK92MZJL+zJc2jamgY8KP8N55g7RdOABVbtkiGG18WrQH3MduHyDXo+aZ
	dGFuaDP3LqsfIPrJMJ7UeyhLjI9sQqrKAc1N1Vev7tNfjW3LrjK6cYw4k8AuYjFJ06yStIiHbqd
	UnXhFmm8xRr7c7SLdhbOW0+hG9NZlM2mI47yEOm+oYx9eU8fYgcaOX1UDDu1UvS4e/s7viF0LA7
	iW4GB4+tsKkvS5Nymygw/jSpAWFVdIpFgyAOuLLoRhtGk+eYzvp0Ec1+JMQnOozjKx2BtC4ccsc
	flpsPMUM01DBQ8y7BDmX89sD+sAqauA25qF6GWZmhCOZRW5eZ2IlyVPkVJxkxo61XTPSEiew==
X-Received: by 2002:a17:903:2c0d:b0:2b2:6cab:313c with SMTP id d9443c01a7336-2b281831e94mr231509005ad.20.1775656847482;
        Wed, 08 Apr 2026 07:00:47 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2747612b7sm204465145ad.23.2026.04.08.07.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:00:46 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH v4 2/5] io_uring/cmd: zero-init pdu in io_uring_cmd_prep() to avoid UB
Date: Wed,  8 Apr 2026 13:59:59 +0000
Message-ID: <20260408140007.8401-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408140007.8401-1-sidong.yang@furiosa.ai>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12995-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	RSPAMD_EMAILBL_FAIL(0.00)[sidong.yang.furiosa.ai:query timed out];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[furiosa.ai:dkim,furiosa.ai:email,furiosa.ai:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D5673BD523
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pdu field in io_uring_cmd may contain stale data when a request
object is recycled from the slab cache. Accessing uninitialized or
garbage memory can lead to undefined behavior in users of the pdu.

Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
each command starts from a well-defined state. This avoids exposing
uninitialized memory and prevents potential misinterpretation of data
from previous requests.

No functional change is intended other than guaranteeing that pdu is
always zero-initialized before use.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 io_uring/uring_cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ee7b49f47cb5..fa3a6f832460 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -209,6 +209,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ac)
 		return -ENOMEM;
 	ioucmd->sqe = sqe;
+	memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
 	return 0;
 }
 
-- 
2.43.0


