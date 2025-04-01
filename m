Return-Path: <io-uring+bounces-7337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54FF7A77962
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 13:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B85B16B14D
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 11:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48F61F03C1;
	Tue,  1 Apr 2025 11:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnwshaMH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB761F152B
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 11:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743506037; cv=none; b=YAC3FvnWs3HuI6XyOingLZpun2DM516sNv5lOeP6b3hUjD+jnSdfcGsPlVKOUgxRgn51EZS938S+mWe8JYFxgdnQFpXb0cV2oyJ7XZBi4MOXcJPpEVLBYH7Ldjgb59/rO4p0ZaOmpPnR8uS8Ekud3Hqe8mZ3pwI5dGtvl7zkWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743506037; c=relaxed/simple;
	bh=h3PfWZKJ9rajdWTU/J66W3Dkfa0YNfy9r1cVMiPpfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U9n+5GSEuLi+WKzIl1uICs2KFzwZ4rJgz3zPxKfifuzQc9Z3UId1870sY88L1Td0BGifVm4P5vGJrZ6NSZb5I3LY0zt/+L3dbjUSaUMnIMhZux/mihd0I9vUNuNCE9CIXMA8j30ccLBdrySZ0GR9/RRsl5qzfQ0LENhChEUYHQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XnwshaMH; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso873158966b.3
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 04:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743506034; x=1744110834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d8VgzqLujjrPXiDxkuhkU9mtMANnUUowTT3lA7YHtwE=;
        b=XnwshaMHL4QPGbNWHdlZNViZEC/wUkFlo/nYJ+Z51xCiqwYLy0POsVQRXqtoyx3DUd
         GAr3gqFvalUoWH5p/grQyESV5xDGzkanC46ecwSwG5W3ssskMpCyjt1VSjvfysQmu75I
         RYuL2o546RDwjWVy/V1h/EWZOX+J+tbeumhbgH48BUfjZ56VztrYytLs/+lQyd4Ksp6e
         9OWzz0dF6FqG7/DFd0bJbU4lutwk/xxKcV1JvkUkeEUnUqlM5q4SG91ajTT5T03xfBzs
         LP6e5jAAUi2bjb3M43mZxcshpkXvsZnUmJOmTZwTKeskE7TSqgKhT4fBWT9QqnAAPq+N
         fp5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743506034; x=1744110834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d8VgzqLujjrPXiDxkuhkU9mtMANnUUowTT3lA7YHtwE=;
        b=kH4WbSArRV0qmHtGSQSh2UQ+EKlYV01BLZy5hLKwKx9MTsxQ4AKqh5y/kWG7i8lMxC
         iEeNvGAjv/UAzJVaZlutPWiZCueJhR3e4bFCm5oyiXalqlcBHDbPmLJTNsZvniW+TUwQ
         JnImJexMU8rtwBZc0J1GH67mG+oR9cu4EpMS+hbYrhMYIALeTspRN232SmSTugL0lJqr
         V0jHYuSp5HYuyfEVEaWRfeX4QhFeWohmeq6OLayL+6YDUFKjpCM/AdEv3nkK6CNaMgPC
         pO1UuQFM5LbnuKUduQlg8pfkUYWyhgcQzPRFJtvLZPCndh3lrgToyKYKPOvoXEpOFtb4
         +xZw==
X-Gm-Message-State: AOJu0YwLr4j/qBzpDImLxdedEtbbmkqp3M3HsXNm5XSMK/15WzhTBCup
	A/g6bC6V+xccAkutc+OswIsBEPl0OaCpcUz4hzFO6QlbQQcRew/iNfEC5A==
X-Gm-Gg: ASbGnctIkBTj3lIkWTg6pXZGvDQ1yvoQkWB06am/u0rXi1Z3rdhvxdD7B9vJx12fAT4
	ke4Y5Z8sb73uh8lMXyMG+FXHu5hMDUSp8+Xgt4yqr2N3Qg2zq36U/TvC7ILqWacf1bMejwjFStE
	/CfBjHG08NcjqqZBArxjtF34EBGKg5Yc9HWndROGL6aSIQOuKLSATN/umRqdmeg0xgXlvOi21KN
	UwkQQ/WGz/8X/Y4mDXz/KN7wl+7+hXjySksuqC83MTQYlfiCfAH8uyb13UsFZDpPWv2FluQbkkM
	P/Vu0ClLOPG/on+eYWipgTbOGN97
X-Google-Smtp-Source: AGHT+IHcAwquHhy/ZZPrzqcOWoOFuvbRbF1wnIqk2yBgE+wgKVUl2sd9IJmjAgSO2Um+nO3UUg78+A==
X-Received: by 2002:a17:906:2441:b0:ac7:3918:752d with SMTP id a640c23a62f3a-ac73918872bmr891364866b.58.1743506033690;
        Tue, 01 Apr 2025 04:13:53 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8c87])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc17dfd41sm7114467a12.73.2025.04.01.04.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 04:13:53 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/kbuf: remove last buf_index manipulation
Date: Tue,  1 Apr 2025 12:15:04 +0100
Message-ID: <0c01d76ff12986c2f48614db8610caff8f78c869.1743500909.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It doesn't cause any problem, but there is one more place missed where
we set req->buf_index back to bgid. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c576a15fbfd4..0798a732e6cb 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -95,7 +95,6 @@ static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 	 * to monopolize the buffer.
 	 */
 	if (req->buf_list) {
-		req->buf_index = req->buf_list->bgid;
 		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
 		return true;
 	}
-- 
2.48.1


