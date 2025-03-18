Return-Path: <io-uring+bounces-7116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DDFA67CD2
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 20:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EBE1425C24
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 19:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E342135A3;
	Tue, 18 Mar 2025 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JgHFN4NM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB5E214A69
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324852; cv=none; b=J1esnDzxePKJh6RsPCuZNkxVodz6vmH0NIRjH/1LwPNUQb879/raIIN0TE4hpVBvXXm4Nlo9zmVNubrusGzTh1ObCCsOo5QiWmZJAiWa+4hp3SY+o3Uj9R0Mjy//mnDZpV9qn1DxciI0eSMUXFkiywNTwDFvhkG3kv0uHiOWbOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324852; c=relaxed/simple;
	bh=7u+IjDwO6+F7DI7uchGCYv5muBEp0ShcxZa0CbC1aiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L33QS94zGiwFiAOdFg+pGiyd/YB5yP95IYd0VHQBZAlBj4zkduFn9g+jkj5mXcL+skflbxb4x6sL/6kde1Zd/DMMPffiOxYXPszu6Nz7j1Cnbn+UK4O/h97kMhA7va2QY1gweB0G1zsZKNWcL+KdTYKc3sC9ebP1hdoDodQBXUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JgHFN4NM; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85dd470597fso117609339f.2
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 12:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742324845; x=1742929645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ot+UoxjARjoK5fUaxnFU+2GwMHtgeInG0/YoXF7TxQ8=;
        b=JgHFN4NMWbWTBPaq/xQ3y7xFhapzXnMvVykqlYUtRhe6bilU5aYcvQHtUcuxhld408
         Qb+GR5Ak7GVKGr4+lcGkwPk9jqx7lWB5epNzS+TM1L7BC3rRhgmWZ9MjpToTBP7c2nBs
         iGedFrDxi2uxH4es8LsXaz2TdUTp6/4mvt0seJ5CicwfM+AMS9QyPACwqZhPMK0QNFsB
         hC7zvrqxhk62G6Y4xuucP90tjCeXD9lXnOYtthDwpISF4d/qyQzKCU5RFxqHUYjry/ut
         H105geSNRYzE5Ri3KaRPtHtMjinMwg4Jlg44bBzp7NvRRVyp5BCXo/CUPn4HqeIoWsgP
         e94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742324845; x=1742929645;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ot+UoxjARjoK5fUaxnFU+2GwMHtgeInG0/YoXF7TxQ8=;
        b=JjmBB3nQCzPDF4PVI7RrKnCzpBL3BSbpn4Mx2kEsEbEXDtnPXq5UDaghe8dBlUY6Or
         m8l47o3muSfj5sdeKHQreUPVSHx2foQTHvPg7T8xsOseSGrSximpMSTJmIftN6IjK61R
         5Lx79bJBQqlRBx4+WRyvofjJQkobaaFwA0VWDLeEg5wfOmRai3uOuSj+jg2z67+Svsqm
         FytwCik+x/UYQFF8+UHAW7km8icpgwrzz2CwocttTRuRqbJBM2nMLX4dJaz7S0/sA24F
         W3RW8MJ4CM9P2AgpKGuO0SVrbqCpUSvFvOoAVeroyYUMZ3MpR7mhzCT6Z7nD2BNzkTJC
         +mPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV10usrIghepdh/n+YSWc+S1nd54FKLtQOwowrn/x3BotaBFKfnwaSpG6fj9YpUqbtsHKkSllJoKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvADSiqaWe0OHnU6/qHWnlz054g7Rs80/vmBVeQOQL5/Vs7sk2
	fiU91TiH8C0WGr0l/55AHlkZPLscShhNtIGJJI7ngvrd5HNty8GrRMgkS90VqrQ=
X-Gm-Gg: ASbGncu6+0BmEQKYT83AxIy63lfhDLeQ5u7gtHFsKazr6cHWUHj0uZ5W+DsZVYGtURU
	XuY1yN6sVMnpARtaNAnBrxsh5+e3/1+XrdyUgHw6lVWUxMaquwAbon5q3CvE5R8IQvH4IoK34wx
	Hd0N3XKi0HjJ8seJO5EVqkWmYLwarBGIJ3aSBMHGJ4YCJ1EbYIkJk67Hj9AAVeXSomF8Qp0TAtF
	otmkTUCty5m9WJUieUhQOvUcs4fX2lvZkSUOhNmM1Mpn/EQ1mLaEobwxifqJcQ+SKVZueL7ZKT+
	O4/dgTNgrRiTlIIFPDxqRO7mtZ94YbPlk1RmrZbRnA==
X-Google-Smtp-Source: AGHT+IHcMcUmgc/6cRGq9lqUuozc5Gqv1nKlNJjLpTLDgmmpVYYIwNfBe3wFAK/zGFyhAHDHTYXkng==
X-Received: by 2002:a05:6602:7518:b0:85b:3791:b2ed with SMTP id ca18e2360f4ac-85e137e1516mr12150539f.8.1742324844949;
        Tue, 18 Mar 2025 12:07:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85db8777e2asm271770039f.11.2025.03.18.12.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 12:07:24 -0700 (PDT)
Message-ID: <01298280-c58c-4cb7-846c-b456132c9eda@kernel.dk>
Date: Tue, 18 Mar 2025 13:07:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] possible deadlock in io_uring_mmap
To: syzbot <syzbot+96c4c7891428e8c9ac1a@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67d0bee4.050a0220.14e108.001f.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67d0bee4.050a0220.14e108.001f.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz invalid

-- 
Jens Axboe


