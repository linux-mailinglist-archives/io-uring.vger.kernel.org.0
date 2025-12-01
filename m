Return-Path: <io-uring+bounces-10872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C2747C990BA
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 21:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A52FF4E1473
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 20:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3812723EAAA;
	Mon,  1 Dec 2025 20:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FClK35IM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619F36D50A
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764621406; cv=none; b=c5lnezmG3OhSuaqsIUxgNWXnQzdqUkKXRUTcQhhVDNZLb71yIplW720Z86lo//hQnzjAij9Nrgor+1m8Pjz+pCxa4iJeDXzgEckqeD+GwB+BChcDNek+Fkajj6FCh4XhA2XLQlnjmCIuvq0JJcXDG8EYnpRb8BSPxaKBn7B1u9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764621406; c=relaxed/simple;
	bh=P+jY1ovN4fcrZTbUjNDf5FrkIOjNvzQAX4yEYxK0hYk=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To; b=CS6l9b9DxPESo1cq6ZwdSjx05j8kf9oPXEtdxblhNIssVOaPnHBJYYHYSQyOlg4LenpIvhVKTDkGtYnBbI6YgM5uc/A5Sk/ryQO29CGUyvwpzPfL9kRRLrGq0eIiv66LcZonKxSOH1Fhnyt28vctScIBLJjImtafxFU1mONbYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FClK35IM; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2953ad5517dso46207475ad.0
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 12:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764621404; x=1765226204; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:subject:references:cc:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+jY1ovN4fcrZTbUjNDf5FrkIOjNvzQAX4yEYxK0hYk=;
        b=FClK35IMSLdZp3c61b3+5XA/0/dwT3aJwnM2jOd67jVx62qlGINHJ3Ps1VIBSEp92W
         eSP0h2emPBVHOkdBJ2Plsl7imBMer7MqwaYr3cVcjMwX837xHW92wx88aSlYqT3bKbCp
         0xl461E75N950DiLLOl5nIABPIJV4E0Rk1eRBfB/7O+GvkKvLLKi24q5PzczIHT50TG2
         SHZY7I35lP7P9jaWoXTk59yCiJhJKmT2GajYoS2plxigCbgtdZ49YXmybLTW4HzMpBxL
         NoZFHeHwi+Evs/mc/NYBtmnO6bnvqkam8cOYzbSWTQ7tHuMD0IPEUH1/c0XE9I0GnXzV
         cKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764621404; x=1765226204;
        h=in-reply-to:from:content-language:subject:references:cc:to
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P+jY1ovN4fcrZTbUjNDf5FrkIOjNvzQAX4yEYxK0hYk=;
        b=WesVYLcjvbBivutduCIzsjS32t+EjJUEL6XPqOELlv8iWcnMFb4s227E55EXkVA78v
         xj8VeY9ioOLbciAbxTde10FY2SUbkZMIT2YQzlykjktT45CGzKSIoEGbEKBglyxJuK2m
         bOuemmsQw45yjrjHLQ496JkbloKKLf+sC8tFWg24a9dfHPDOforUd5BMcs25jaJTIJnh
         3/vNHNWLpwppPsTe53aYD8bYbcgz++XRAa4F4jB1j7jKtRn9Mh3G9N8MIJYjffVkAmO+
         Fem0vXjMdyrsjnwVyPSQOee9efbYKBmHR6j99qgtXmVjEdl3Hj3WxFLxkbbnAQ3cqHbc
         Fu2A==
X-Forwarded-Encrypted: i=1; AJvYcCVXK2hnwH81oBLnxfRUo3+t5y16aKd+gI21Ydwp/2Lf7UwUg5gp2xe/We8WzK3cK6Xnlww6DalpyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqxrz0l4QssV74U3BIBCq440oseN9e/4Rf7K4PRNZEIgOEqCxw
	BH0J37m2qNb0NjjLpuugEeYNOGB7iVg2BDnHdtQd8mzMs1HhrcR5cw2y
X-Gm-Gg: ASbGnctut1L9NJERQBV5Q9YcJSjUT2WsUa8OMXw3nIe5QzEnhka5e/6HksJ9EzVtZ/F
	k0O8kHktwUavy1QHPahc342qiWONE0LOacTsddk45ht98nrI6UzXw3mlcbimhuxw1N7Ymi3gVv/
	V/gzBpx8Y6cgIHeVx8Z6Ic93S2fw/lohyD97OljDoEQPtx0VL+TTmAFB/O+Q3pPXwWwZcokJS7B
	6vlmSa7anNLfE1ZlEvh5emYDySQ0ets+nsSQ9c+LjAICh0r0BYbz6e7ccqzKojfEBXOHffKBDfH
	LI6+D/K78Djs8x4QHKrTLsOJvpCXZKUp56hNtxmIVvYAIrqk3voBm5UE9F4zZJIJGIbTR1mjy4z
	oI48OelzJz7+3HC4rVg64Ych40Bh1Wscv/pC+6ag66gGU/00fMvE+LUioArYogmtWnwJWLMbhOa
	eXM1w5scVprN910kNwBZviQT8AGFjZSMmSIjvh7xpvCByqnx7sn1rPZv8mhC24IqYtuNXxl0SjY
	Rsi
X-Google-Smtp-Source: AGHT+IGAy4vkeldz63V3s5dMaPtcnVzecXwEr6blH5Upst+nT264F0xnsxefQHEsvbrwBWuMDEhx7Q==
X-Received: by 2002:a17:902:ef50:b0:298:34b:492c with SMTP id d9443c01a7336-29bab2de50amr302069695ad.54.1764621403798;
        Mon, 01 Dec 2025 12:36:43 -0800 (PST)
Received: from ?IPV6:2405:201:31:d869:85c2:e55f:c7d8:50f5? ([2405:201:31:d869:85c2:e55f:c7d8:50f5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce40ab81sm131370025ad.3.2025.12.01.12.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 12:36:43 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------AbkW77UAfsRV0h513kdh4LJN"
Message-ID: <d08c0c69-eafa-4768-906a-50a7e039e76d@gmail.com>
Date: Tue, 2 Dec 2025 02:06:39 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
Content-Language: en-US
From: shaurya <ssranevjti@gmail.com>
In-Reply-To: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>

This is a multi-part message in MIME format.
--------------AbkW77UAfsRV0h513kdh4LJN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master


--------------AbkW77UAfsRV0h513kdh4LJN
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-fix-memory-leak-by-freeing-cached-requests-.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-fix-memory-leak-by-freeing-cached-requests-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBjMzBlZmExZjViYWZkZmUxMDQ2YTI5YjBjMGYzYjdmN2I0MWNiZWE0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTaGF1cnlhIFJhbmUgPHNzcmFuZV9iMjNAZWUudmp0
aS5hYy5pbj4KRGF0ZTogVHVlLCAyIERlYyAyMDI1IDAxOjU3OjQwICswNTMwClN1YmplY3Q6
IFtQQVRDSF0gaW9fdXJpbmc6IGZpeCBtZW1vcnkgbGVhayBieSBmcmVlaW5nIGNhY2hlZCBy
ZXF1ZXN0cyBiZWZvcmUKIHBlcmNwdV9yZWYgZXhpdAoKSW4gaW9fcmluZ19jdHhfZnJlZSgp
LCBpb19yZXFfY2FjaGVzX2ZyZWUoKSB3YXMgY2FsbGVkIGFmdGVyCnBlcmNwdV9yZWZfZXhp
dCgpLiBUaGUgY2FjaGVkIHJlcXVlc3RzIG5lZWQgcGVyY3B1X3JlZl9wdXRfbWFueSgpCnRv
IGJhbGFuY2UgdGhlIHBlcmNwdV9yZWZfZ2V0X21hbnkoKSBkb25lIGR1cmluZyBhbGxvY2F0
aW9uIGluCl9faW9fYWxsb2NfcmVxX3JlZmlsbCgpLiBJZiBwZXJjcHVfcmVmX2V4aXQoKSBy
dW5zIGZpcnN0LCB0aG9zZQpwdXQgb3BlcmF0aW9ucyBjYW5ub3QgcHJvcGVybHkgYmFsYW5j
ZSB0aGUgcmVmZXJlbmNlcywgbGVhdmluZwphbGxvY2F0ZWQgaW9fa2lvY2Igb2JqZWN0cyB1
bnJlYWNoYWJsZSBhbmQgY2F1c2luZyBrbWVtbGVhayB0bwpyZXBvcnQgdGhlbSBhcyBtZW1v
cnkgbGVha3MuCgpNb3ZlIGlvX3JlcV9jYWNoZXNfZnJlZSgpIGJlZm9yZSBwZXJjcHVfcmVm
X2V4aXQoKSB0byBlbnN1cmUgdGhlCmNhY2hlZCByZXF1ZXN0cyBhcmUgZnJlZWQgd2hpbGUg
dGhlIHBlcmNwdV9yZWYgaXMgc3RpbGwgdmFsaWQuCgpSZXBvcnRlZC1ieTogc3l6Ym90KzY0
MWVlYzZiN2FmMWY2MmYyYjk5QHN5emthbGxlci5hcHBzcG90bWFpbC5jb20KQ2xvc2VzOiBo
dHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWdcP2V4dGlkXD02NDFlZWM2YjdhZjFm
NjJmMmI5OQpGaXhlczogNjNkZTg5OWNiNjIyICgiaW9fdXJpbmc6IGNvdW50IGFsbG9jYXRl
ZCByZXF1ZXN0cyIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6
IFNoYXVyeWEgUmFuZSA8c3NyYW5lX2IyM0BlZS52anRpLmFjLmluPgotLS0KIGlvX3VyaW5n
L2lvX3VyaW5nLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmluZy5jIGIvaW9fdXJp
bmcvaW9fdXJpbmcuYwppbmRleCAwMjMzOWI3NGJhOGQuLjk5ZGRhYmIwN2ZiZCAxMDA2NDQK
LS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysgYi9pb191cmluZy9pb191cmluZy5jCkBA
IC0yODY4LDkgKzI4NjgsOSBAQCBzdGF0aWMgX19jb2xkIHZvaWQgaW9fcmluZ19jdHhfZnJl
ZShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCkKIAlpZiAoIShjdHgtPmZsYWdzICYgSU9SSU5H
X1NFVFVQX05PX1NRQVJSQVkpKQogCQlzdGF0aWNfYnJhbmNoX2RlYygmaW9fa2V5X2hhc19z
cWFycmF5KTsKIAorCWlvX3JlcV9jYWNoZXNfZnJlZShjdHgpOwogCXBlcmNwdV9yZWZfZXhp
dCgmY3R4LT5yZWZzKTsKIAlmcmVlX3VpZChjdHgtPnVzZXIpOwotCWlvX3JlcV9jYWNoZXNf
ZnJlZShjdHgpOwogCiAJV0FSTl9PTl9PTkNFKGN0eC0+bnJfcmVxX2FsbG9jYXRlZCk7CiAK
LS0gCjIuMzQuMQoK

--------------AbkW77UAfsRV0h513kdh4LJN--

