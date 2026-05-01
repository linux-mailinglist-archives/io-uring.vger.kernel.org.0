Return-Path: <io-uring+bounces-13196-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMz+Gsou9WknJQIAu9opvQ
	(envelope-from <io-uring+bounces-13196-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:52:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C17924B0197
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7078130136A1
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 22:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D1637C917;
	Fri,  1 May 2026 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYH5EwSY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B836D9F1
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777675975; cv=none; b=n0NGCwaud6dURAANxyGlUOfmTJ7jLhFtQXa7Hq19PmREwoFdVyEtBgP+fmu4KzPw4/B6rp+uGLyWnb86WAC7MZsk20CriS/fUijpxxq9/NGKahBA5OJ1zFHSmFXeveZPsFq+FhaSROJEgXd9B9/VBhexllaWeMUIrsksQwKJgVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777675975; c=relaxed/simple;
	bh=AtjoS2qKI19MPpcUWlsrCorY2Y+IWvNMfP7d5WRBn4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XPa8BSE2sWgwkYjs7Tg4+t0yTU5WEqDNlzKu7ZdYtfP/n6iy7VNbHteDu3cdjNVzaba+1JRObHtjCJ9JudyvIn9ynbxaiSRxQ+DQVvfiMj+Vcz1psv9ueIu//5ewiXDDrkuCHMNyxJ93bf55vz3FGQ833tKhQOo7AdLo/wV8izo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYH5EwSY; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so18858305e9.0
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 15:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777675973; x=1778280773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MlfeI53MSknvI/fVUnhA0O+LrnOrRDS6h0z2W5o3BAg=;
        b=WYH5EwSYAlaJaDYnjaQDU8nmzYuKUH05D98toVyKIA4DfWi0FWH/X+1rUNly2Vw4Z/
         i2K4lFK+rZ5/NbT03k4SSakJqoJEfs2cyfIKiYvKrkId/cgQfqM4eYgQNwP5pcro2S5S
         vZFjtAFdSzkqcPIPgKB7zHq8zTztEuUby4ayGQvzTIOXKfkyManJV9wYAl5NnaC5ZITg
         gnOw0iQfRBVUkSQiNL3FSrnEbLri+7ksc9VfqWTYsuGmNkIbnRCG5w3W67Kg9roJB/G/
         iun6Dif88fHZXAw6Fz4ajJD+KfHDqkOU4Bozz8MpoPrpLofpT7zD6E2ohSbw7n5eGK6F
         Q4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777675973; x=1778280773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlfeI53MSknvI/fVUnhA0O+LrnOrRDS6h0z2W5o3BAg=;
        b=Ta2pzoQR1XnKwpKqS4x+GaFSRdV1g98nhbp/RXSL99OUp9PCUOw2iqUTUvqod8DjI9
         aHxyCUTnMaQuSvYVGPYbF3kvvwzwVx9F3kwcCTpl9sQE93UFI9nTOcskHFq/BNzOhomQ
         EjvsopsGZUMf/6Hmn5EmiOTcxPa90cIlccDFeX/IZiOb6i7qc2Zj934kG1K9SMBm/bTD
         Rf4Y/9xsxJSCn3MnrdQxxK+PpCpk+xViVmx+X2GuaMMYxCvPjPGyr8p4cNfHqvhUfl95
         Ol7AqQxNEbXp/BpidRAGDTFhsFeH1HtAEYUTNt5k6Hc/CZUCZ3un/nXGBVE+qgxfPVKs
         2DZg==
X-Forwarded-Encrypted: i=1; AFNElJ9Oc2UhuDPXmu4LIb+vWqlGEsbdrktKY/FW58CJWS1CEzK6Mx18x8mMP6MQpTHdlueFaJXKu3wflQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqHAnE2c++1YXjo1MuwZlbOr1zFRIoJxaraktVW/IGqyb/9PAt
	FZit/VLhCE4CddqpRk5fz8NgEr9Dn93/qBPpO2+xg7wR9lVQL1vU4WM2
X-Gm-Gg: AeBDies6j17/3b0rfzq8DZG6VS39fdQKkjTtKA99RSCrMhxTziPl9oImadBgR9EE0Mj
	i4Mv8cAJ7ukWFRrXFqjM+bZOMNzmCnSOsPDvFPKNCKn5uvwcx7jIX1d0mtMARKqAkcWF6HgKAYE
	H6FxB7YDkn9PGVRL/7oer5WI21uFHfg4wB+jiSrnQdJAG22vKTTe8JOFC+4YlS0iSqfpqfpucbB
	+TxeHdYDBSUMuvn9D2DgjomGffVf6AUkOADhWBB9W9RAYF6lc2sRRQuR6iM3XPXT00iCYlLd84T
	Ou8g7njROAb09n2O1K34zg7iD/yzcKlpoA7jtYlr/M6G+EhY0dxRPVnOJEYdsyo9mOHbMgiZB2I
	NwHb4WlTh+V86/Wk/kKTFCHB01Ypy5VWeWSrHCszvzOSIZDvz5ycHBIfrbO1aKQt0Z26JRz6FZJ
	co5fow8XCerd35JJX/hsnqeLDS2qj4KyymOGI1y2Pp+msO47HEf0UI+HKB6un8M9eWKENmWycKK
	UXfJsckw9kkRU6pl4in+rNE7A==
X-Received: by 2002:a05:600c:4e4d:b0:488:af7f:7707 with SMTP id 5b1f17b1804b1-48a98663189mr15919775e9.18.1777675972957;
        Fri, 01 May 2026 15:52:52 -0700 (PDT)
Received: from localhost.localdomain ([77.124.36.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fe93266sm23857045e9.3.2026.05.01.15.52.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:52:52 -0700 (PDT)
From: Kai Aizen <kai.aizen.dev@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: [PATCH 6.12.y] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Sat,  2 May 2026 01:51:54 +0300
Message-ID: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C17924B0197
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13196-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaiaizendev@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a68ed2df72131447d131531a08fe4dfcf4fa4653 ]

When a socket send and shutdown() happen back-to-back, both fire
wake-ups before the receiver's task_work has a chance to run. The first
wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
When io_poll_check_events() runs, it calls io_poll_issue() which does a
recv that reads the data and returns IOU_RETRY. The loop then drains all
accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
the first event was consumed. Since the shutdown is a persistent state
change, no further wakeups will happen, and the multishot recv can hang
forever.

Check specifically for HUP in the poll loop, and ensure that another
loop is done to check for status if more than a single poll activation
is pending. This ensures we don't lose the shutdown event.

Backport notes for linux-6.12.y:
  - The do-while body in 6.12.y already places `v &= IO_POLL_REF_MASK;`
    just before the while-condition; the upstream patch moves it
    earlier so that `v != 1` in the HUP check refers to the ref-count
    only.  The backport does the same.
  - io_poll_issue takes `ts` (struct io_tw_state *) here.

CVE: CVE-2026-23473
Cc: stable@vger.kernel.org # 6.12.y
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[backport for linux-6.12.y, verified 2026-05-01]
---
 io_uring/poll.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -297,6 +297,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
 				v &= ~IO_POLL_RETRY_FLAG;
 			}
+			v &= IO_POLL_REF_MASK;
 		}

 		/* the mask was stashed in __io_poll_execute */
@@ -327,7 +328,12 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, ts);
+			int ret;
+
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && v != 1)
+				v--;
+			ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
@@ -343,7 +349,6 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);

 	io_napi_add(req);
--
2.43.0


