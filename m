Return-Path: <io-uring+bounces-988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5EE87D669
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E078A1F215E5
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 21:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44813D55D;
	Fri, 15 Mar 2024 21:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3dY9jwkO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713017BD4
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 21:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539701; cv=none; b=MOmf9SxyWbEY//qfYbC3ztILovzOtI+a68wcctu6a4v0nMkFMUABReCUA8Pl5u9Py/pZn9v04ccIQUDjjt92meDo0AUYnQJvmr79wJyl2Cl3/fQ7GviHtSP/oBBGSasOyV5SVYLeEryYtjLeHkcfkwRZ5IuBEqgmdrZOMDBE8+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539701; c=relaxed/simple;
	bh=1LErSloFkMFZqDRkBHBpRkf6gW5lNLsuLmqGX0L/uAI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=FSTtxXjts36SBeU3DdyKzs9lnO4wX3oE/FEy5suh0uzBV1bvjzrxkD8mYRgqQZU1vPul0LMBJCGAXpj+VynXMb/K4r4wnCvGpPwNg+iqoqGIy6ZAmGGqEwy4yS/Jn7rhEQO7CS3DNFwqMW4MNi77cTDRRF2LIYivPahiYoOEn5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3dY9jwkO; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so723668b3a.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710539696; x=1711144496; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMxk5TjUw0eXd1YFVhByMNhlBmZishV2Mo2w/DBgqXw=;
        b=3dY9jwkOclx7he0iHakAcolgVEhDtnDZ/cdiOT6ssgAsd8w5W/4dxfvetEZ6OX7uWu
         UhXiQY6tJK+t8H5JTKAM85cQXhxfpfT35KBE3UqJIV6GWWm5yY7Jz7rNqzZb47DRE+55
         Ooa/QQco0uwcPU2kaPmg6nLuIAqXhSETadWCL+29qXaX4ZMhxYwGZosWxYuHfwRzmPAQ
         0OHZdlvGsELa1A2PXDa2KFWzaCAIPkBstWO/m74JO+yZ7ZlUoUBUCQ6By6rhUpolbwJv
         zUo3il1MMhJAakjxfKx229/wjkPXZc7PChRBkJ5nZnhh3p+aNYs9EYWivObKScgvjDqr
         OHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539696; x=1711144496;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BMxk5TjUw0eXd1YFVhByMNhlBmZishV2Mo2w/DBgqXw=;
        b=TtTy3duT4/qNpAPWf5FtB0U2zrX+w1gvGszLOU7dfhs5ZiFvjDgNWBzx8Ixu3sQMHx
         Rk3XWx3f1kqxrifN3MVM6noqwqQtP8Fx4pk7GuKXk+EdKVpksjgMr66avK8p7AHykysN
         4/jKzdioK8EjAXpNDjGbmpkl3tuZMPAKKhnlHWBdXii3dwQf2WpnrnSMepEuHFRN4Mwj
         t02xLHW8yb0+ySL4Exko2KJk6AEecm9Q6FOlfAACzL1No39cUVs6XC/kSxzjeZ3Iwliu
         4tlXJPTNwyDLSPYHJz04QovbaDNwEAiwKyH0Y2v0c24aaWPJ2A2RXiz9e7mrKe1nfXaF
         0Q9g==
X-Gm-Message-State: AOJu0Yz4sucILi8flfuCVjHuroUGyLXhnCm85aPyEscRHecuIGhWwImS
	aYpcx07xkuxnAAaF8GzPJ0/uIMl/3Ktxxh/W6Oaz758cByqAJjWj/VVHhv50GB++I5Fdyf8vB9P
	S
X-Google-Smtp-Source: AGHT+IEnIx16l1C3SYvMsdoEEta0MjXNjnaK0ljLzMYoAXp8cL8hE6CPd/mLWwaiZTnoanL945eAHw==
X-Received: by 2002:a17:902:ea0a:b0:1d9:607d:8a26 with SMTP id s10-20020a170902ea0a00b001d9607d8a26mr6460162plg.6.1710539695797;
        Fri, 15 Mar 2024 14:54:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c8::17d7? ([2620:10d:c090:400::5:ad40])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903120900b001db5bdd5e33sm4375372plh.48.2024.03.15.14.54.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 14:54:55 -0700 (PDT)
Message-ID: <434ee45f-3587-43ef-96b1-19dc2df5f3a1@kernel.dk>
Date: Fri, 15 Mar 2024 15:54:53 -0600
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
Subject: [PATCH] io_uring/futex: always remove futex entry for cancel all
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We know the request is either being removed, or already in the process of
being removed through task_work, so we can delete it from our futex list
upfront. This is important for remove all conditions, as we otherwise
will find it multiple times and prevent cancelation progress.

Cc: stable@vger.kernel.org
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Fixes: 8f350194d5cf ("io_uring: add support for vectored futex waits")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 3c3575303c3d..792a03df58de 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -159,6 +159,7 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
 		if (!io_match_task_safe(req, task, cancel_all))
 			continue;
+		hlist_del_init(&req->hash_node);
 		__io_futex_cancel(ctx, req);
 		found = true;
 	}

-- 
Jens Axboe


