Return-Path: <io-uring+bounces-11217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0B2CCC602
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 16:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37D8F3084DB9
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 15:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB1328850C;
	Thu, 18 Dec 2025 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g3SnUHkD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183AB1547F2
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766070091; cv=none; b=Zd1KXLCQztWmZjPI/7VxfR8huiT3eBA3H2bLPn6oUf38XRqpfskqE13/VWa2zbPyV34wQe60CdtA1yLi392hfS0hQEwKfUKnzDCIgSPK6YZMreRs7jGcRnCsrE7ayRYj1XW3x/ZMyT1uydcaXBwTOR9+g/lWFkHxEOeYNjF1ExY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766070091; c=relaxed/simple;
	bh=xuxYpHZyXgdRB12usLdOT6BuulW7JinEFCOoVCvBrAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqWQ5Wo85KdJnZSuE7NCQ7yb9pMNAyWSY5hp4wC2X61HJ+tWuh5y8wfWbQJITKOSmMcLC4dupLveRJNIYaUqmgIifUwzosimAsoqrrQMLN/YWc3UFPh+DTEaY7isUZuJ6sJxDDjWd2Cdn5tT1ZyNhG8wYoriS8igzBt2OPTzDNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g3SnUHkD; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-45391956bfcso545986b6e.3
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 07:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766070089; x=1766674889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkCfuBffdvy1ahpgO4ryU5C0fH+X3z2hQTwZhDTxw+o=;
        b=g3SnUHkDciTxN12qlWxzvZUkmedWYbBO69JzHDDwudvobB1qIx72cgggsuycg8yu98
         PabIvLqOgca+y+McDIMCelU4Uh3cr3gH0tOsxFhy01WUQrK8OelEnAjfLNaI27ee6myc
         fyDZz5ASJpBkAfT7tdDlDW2IzVNFk1X11UaV332+G8kRsQwtKkuaxn57ZC+W/WP5ek9+
         s6nbbxMjVBnqV0VBwNm2ab1bDxwaHh/lvSOzhTIfVafRZTq6uFANDuGq/bGx+7MiiXiQ
         w3sd/XQ89aihs1AdBKDbbhwT1SQ3EMKCvx53s9W6wfZ4p3DGzO6vEh87cUO1XEEcc8oq
         qVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766070089; x=1766674889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fkCfuBffdvy1ahpgO4ryU5C0fH+X3z2hQTwZhDTxw+o=;
        b=IxvgTmIcsaKZtfiwimDy4h3tw12fiavr3oipE5hTbLXMgfrpCIpTm+2EA989i7ZAzv
         VoLU3tQQfDsF0X25lJ76BMcyTZM9/zXiM8maRnwRNwlwEHDt1jWrCQsS8atRhwVrWwV3
         86sVsDPv4xVzceEld2Qb4v4N5Cq+hcgL+apUxR+78QivPng4bkb+KExkKQZh83m3qIX+
         yx+RTToZjU3R1tGFRdMZE2a56VB82yyAhomKtcGEn04IJHhNIZBnwpbdAXlQux79aKaV
         ZqXnhXQNbYSpbUNXyLFgE7EY+vOG4iCX8Cynh4G3T6Zn2ay824Y9UIRgxhGtel0luAsy
         IWfQ==
X-Gm-Message-State: AOJu0YyYnoMWvIi86FKHP5hE0vjIqTqE0nfH2yausxdfhEXESxqIp2Vm
	D3vuYP9DosbKLdtKpkKwkYCqR7FeZaKxmMULcD/AjtsTBXWPxUF292rCPellcmtfW8Q=
X-Gm-Gg: AY/fxX7P3cUcoqYYHbaRfjFfu8TWNnx0xBpJuCgjXBYPg+QfiWbWTmwsuEFzCg+QBZH
	GVQ3YqetSuliHfgk0glFcQbH5PL0GhSbocMA314ETJEa2ewgZ2TZL7+z54cAOc0GaDONjciRJWl
	PObzAAV82hpzTsojPq7TxbIUQ0NBSEphH2ITxRQc2OaIAr1wU9TnymPjwd/5iB4ON4jc+CvHPiI
	BMiZit0uchpZgMh5wKONc5gzCSmfcTFmVJfzZ9N/pvPJVq6my4OJC7F+1ncwoA/EDc68lvQ/+L0
	HeZ4IObsA6mluVVpQUwlYhiqfKSArlsjSuho8c4tzErdwlWuUuXUOgbamXhUFlertKVbUHDr0Kr
	mQuKT7+HYE+eZszn/9GOVepwTEKIXYfM4ErX8BMqk9GKQY5oerKsZnzWL23DSJe+IlCjCGQ==
X-Google-Smtp-Source: AGHT+IHNqQEyO2+zm0WZX6kMf8tMyinPk4DY7+372q7upiugrQB8KXle70xpWHUfWtjzKhWHklipKw==
X-Received: by 2002:a05:6808:c291:b0:453:746a:c61c with SMTP id 5614622812f47-455aca2f25amr9904875b6e.66.1766070088843;
        Thu, 18 Dec 2025 07:01:28 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457a42fe963sm1327816b6e.1.2025.12.18.07.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:01:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	kuba@kernel.org,
	kuniyu@google.com,
	willemb@google.com,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>
Subject: [PATCH 2/2] af_unix: only post SO_INQ cmsg for non-error case
Date: Thu, 18 Dec 2025 07:59:14 -0700
Message-ID: <20251218150114.250048-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251218150114.250048-1-axboe@kernel.dk>
References: <20251218150114.250048-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As is done for TCP sockets, don't post an SCM_INQ cmsg for an error
case. Only post them for the non-error case, which is when
unix_stream_read_generic will return >= 0.

Cc: stable@vger.kernel.org
Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
Reported-by: Julian Orth <ju.orth@gmail.com>
Link: https://github.com/axboe/liburing/issues/1509
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 110d716087b5..72dc5d5bcac8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3091,7 +3091,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		scm_recv_unix(sock, msg, &scm, flags);
 
 		do_cmsg = READ_ONCE(u->recvmsg_inq);
-		if (do_cmsg || msg->msg_get_inq) {
+		if ((do_cmsg || msg->msg_get_inq) && (copied ?: err) >= 0) {
 			msg->msg_inq = READ_ONCE(u->inq_len);
 			if (do_cmsg)
 				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
-- 
2.51.0


