Return-Path: <io-uring+bounces-6383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4D4A330FE
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83EDC16842A
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1CD201024;
	Wed, 12 Feb 2025 20:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="asumzZjL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f100.google.com (mail-io1-f100.google.com [209.85.166.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65041EEA4A
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 20:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393195; cv=none; b=WTAlW8H1QXLuyrOp8j1PZsncW4TQRUVT8zCT4ovdRdD1agjd0NbgaSr/WHH7dXHWDsVAeDTfNT3QH6Wu+HClAaMlXALa7Tzq0ujVn2w8DMISEFx8icC7Sb1ljUrrw3Q9VdA+tZJwU1u1IqZ1f5vj0/ujMvZIr+GJM67UpnVp4+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393195; c=relaxed/simple;
	bh=WEbvghG5qG37wCBWMvGFFRMd/IgFtSFjI1yWwCpYjpU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hydJmHqzryVSO++//0mPkZ4DTbeWHjhspszBtLLviJt0DQpKARcSLJWjdBrTsOCRRYiJe27e5z1Dc+B/xvfO5owlFekSRbdsX+3UD5ej/S2CrrZUbSlOZJPnS5pfKWE2BFTw78RIvESNxTqDIyCaNVg12jzA1AKncI/yw490dc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=asumzZjL; arc=none smtp.client-ip=209.85.166.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f100.google.com with SMTP id ca18e2360f4ac-8551f4fda6aso475139f.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 12:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739393193; x=1739997993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C1Szppuqbw+roNwcR7rWxy0Q8IaoVRiOv/Zo+HVKhVU=;
        b=asumzZjLUxObP7y+oqQwbEjVQA+59XA5DlnkgYtifN56VpeXFrMNRI7bJlNvuicXGm
         DoPlYrM8h6VE4rCwTCzd+OWrtneeDiLywZVXs1qRmm8w0beO1CcRz1h+kmp6pz+WB7Xz
         Wxz5inMa8FW9G2PyRrnMnySQAkvelgYkxm24z+DAVnmQOPtDpGjphcx7xk1xMyqp4RX/
         ViUuR6Ucegb2lySKR1KoeK7yVzeGQD9EZsI5Vtcx61rFfM5j9bHjq8ESYJR6ZRSuTqB0
         y8n9RyuLSL2HXpFgL1fU4Wcxt9cLz5Jn87QGURc9Ae7ZjHYClVgVqGbscfix4ZBP2Esn
         jWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739393193; x=1739997993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1Szppuqbw+roNwcR7rWxy0Q8IaoVRiOv/Zo+HVKhVU=;
        b=CLx8k3E/ttgtWaYHzwq4WXD7Fdwn42XDQvkzpW+QXIVUTD6GfBOiM6jZZd65Iwt+jp
         jrRNdhFL+SfjpYxWBkXseZcHyWhVZz6KRMdqRMBgLzdtJQAxAyVEyPBOUtbfufS73ZE2
         OADGjAYTdEM53D9r1fsRlclpyPa+laQdWVGrGFhHITN7PJ+8SHT+Vu/GjLyj8IyrWC+R
         43bf19ngi8wGdAe8FSiyhW5/9MrDi6R3Uch58IffGLF+M+aYVV9A8dnwrE7KVPPXxf3J
         Q8sQ23C2nUd/TBQfRkKUCMVphFb9LgMP+pW62mZbQb6ERizQMy9GIj+9O+c7rPHrWqBk
         9iEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTouup+/UldF0wC5pPQ/K1ABWvqCo+0oT7xFCcoPWZvr5EdKYbLWxCKGAQoelh3X05gFDKL0l6Gg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwR6AiylGN0XO9RXxApp0uEXkId1ew9PauDkfPqX2uERb3HuYuy
	27dCRYCQ70DwV51DmeB+p+QTxRTHFP0jGk3wyo6nhHMuD/FNm1PtX91GfqUgPHVPPBo3OzBH0mf
	sEe65PmHM0RBrUld5SfHtTHMsY33OKduAkL/RGK0Gz5t9f/zN
X-Gm-Gg: ASbGncslZpzqPKAKT9ro7bXyAAkMnNpFdzCbZG3KSccTxKho74OcWYCeY/+aeplsUUG
	C8uPlqtXMBZsGD5dtN8mFqUrWckZ23fh6Fztj7fCuIEe7IQ4bQyqZdVPj6Xs3Dv8dNpUy3QnPZZ
	UDn5K8w1hjM9m4Arbop8btRD8U6qLfz+PGbpEdxs1unAraOggt/UHssfatFBH/JTR6Ykz5Mw3/z
	wcMYLesVNu2yHNuXK5dfMOqZQwN+ugPNvWLDd+Kcs+NQIAuFb1THogo8NJRHlGKBt4StrKz6xak
	X80HFHNHxvQYR0D51QKVUiY=
X-Google-Smtp-Source: AGHT+IERRFz28hVonQcVW2NGKlN7rUa7EdvNtmcD5oahOamuqm8rs+l1MW3XjQINiNLg48cf22LBeVh8KsUC
X-Received: by 2002:a05:6e02:3208:b0:3ce:7ac0:64c2 with SMTP id e9e14a558f8ab-3d17d0725efmr8768165ab.1.1739393192833;
        Wed, 12 Feb 2025 12:46:32 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d05e8d8fa9sm8855715ab.11.2025.02.12.12.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 12:46:32 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id A78583401A2;
	Wed, 12 Feb 2025 13:46:31 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 9D155E41973; Wed, 12 Feb 2025 13:46:01 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Riley Thomasson <riley@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 0/2] uring_cmd SQE corruptions
Date: Wed, 12 Feb 2025 13:45:44 -0700
Message-ID: <20250212204546.3751645-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In our application issuing NVMe passthru commands, we have observed
nvme_uring_cmd fields being corrupted between when userspace initializes
the io_uring SQE and when nvme_uring_cmd_io() processes it.

We hypothesized that the uring_cmd's were executing asynchronously after
the io_uring_enter() syscall returned, yet were still reading the SQE in
the userspace-mapped SQ. Since io_uring_enter() had already incremented
the SQ head index, userspace reused the SQ slot for a new SQE once the
SQ wrapped around to it.

We confirmed this hypothesis by "poisoning" all SQEs up to the SQ head
index in userspace upon return from io_uring_enter(). By overwriting the
nvme_uring_cmd nsid field with a known garbage value, we were able to
trigger the err message in nvme_validate_passthru_nsid(), which logged
the garbage nsid value.

The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defer
SQE copying until it's needed"). With this commit reverted, the poisoned
values in the SQEs are no longer seen by nvme_uring_cmd_io().

Prior to the commit, each uring_cmd SQE was unconditionally memcpy()ed
to async_data at prep time. The commit moved this memcpy() to 2 cases
when the request goes async:
- If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
- If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue

This patch set fixes a bug in the EAGAIN case where the uring_cmd's sqe
pointer is not updated to point to async_data after the memcpy(),
as it correctly is in the REQ_F_FORCE_ASYNC case.

However, uring_cmd's can be issued async in other cases not enumerated
by 5eff57fa9f3a, also leading to SQE corruption. These include requests
besides the first in a linked chain, which are only issued once prior
requests complete. Requests waiting for a drain to complete would also
be initially issued async.

While it's probably possible for io_uring_cmd_prep_setup() to check for
each of these cases and avoid deferring the SQE memcpy(), we feel it
might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
As discussed recently in regard to the ublk zero-copy patches[1], new
async paths added in the future could break these delicate assumptions.

Thoughts?

[1]: https://lore.kernel.org/io-uring/7c2c2668-4f23-41d9-9cdf-c8ddd1f13f7c@gmail.com/

Caleb Sander Mateos (2):
  io_uring/uring_cmd: don't assume io_uring_cmd_data layout
  io_uring/uring_cmd: switch sqe to async_data on EAGAIN

 io_uring/uring_cmd.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

-- 
2.45.2


