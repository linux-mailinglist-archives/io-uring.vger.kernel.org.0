Return-Path: <io-uring+bounces-6855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CE0A494AA
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 10:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E820170682
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 09:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB75256C9E;
	Fri, 28 Feb 2025 09:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yi2D7qs9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3DC1B21AC
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734376; cv=none; b=tlh/OWLIOSl0TPsjjbh133hcVLgMlE/14lkm0i3LrXT6M4gyHOc1mzTigiqY0fHqjBYGLd0un5i/Y5+ztNpPuMI79dtQXvuVHW35UZrTOZgJsZa2dVsKANqgAUwABsXjcHrB24EEC/w1XDh4F9zejKRZssf140kvtjrhwAsryjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734376; c=relaxed/simple;
	bh=5EvpkuiIkE132SJfCnLpkXPr9j2t2TiC2BFxdXcr+l4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UGDCOkl+Gk83fyItRO6V9dWjka40D1b/ggsMJQIVBMcyppQcVDUKDe9BbkGEhPFuqjWrChAGsrfD+xLaQIF45wtTOjdD6gAMOEvYgMKttuyQycTwK8pI776PJLdxA7M+OM8ewMj8tn+5RgXPNCYoAOCnL1BWUoF7cyB94UcbNew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yi2D7qs9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaedd529ba1so206925466b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 01:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740734373; x=1741339173; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0qDMZYERy3pepK/Gz2a9lp4fGMcYUd1BYCpNZiWMvQU=;
        b=yi2D7qs9UOqEl0Uuqag3zimSy8rPmbN7UHBbs57ncP3IuCCNYCITad/wImNWEIrvFa
         e3aYmocZCAYmylx41P88aikIOGsDfZrgN4l/S+OiteJMFxgikmiOqQ3OmOOGQbFQovAb
         LD2nvEo9MLXhUl5QjTeFeA1ISZy+UqE58Zt5gl6KDusQ7FYHTi96fnBkGYhxT46FzwNJ
         tjWoOCIdDVhxfpZC0s820JJuofyF4vq+FJZjOY8hUIgsqLBEp0gLiJw0iLcUMRS8Kyfz
         d5Gvof20VcaqYmzAMEAwYhSdrDfr4kCqNSC89qmY7MqEO9lUjRNKFCGJ9pCr/+u33yDL
         N6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740734373; x=1741339173;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0qDMZYERy3pepK/Gz2a9lp4fGMcYUd1BYCpNZiWMvQU=;
        b=Cv2InADYZgdIgkVVzJ4r6U2uQEU7UzP4H2+NNYnWAAa11+celY0aEhH2qofENgGkFE
         FHIWSMA9Cd0lquqm0mzOMnVPwtAjjHE+mZkZydogOhdQg9jPbxANvw9uHnAI/oxzyn0s
         Ao6MCY+L4F8i1S4xst7o9AJbtCY6s2DJEFr8Kjq5hri0qt2SRCJXwzlSTlqp6qkdVMqa
         Kzw4zXZWT/q34QhBz8I3SeGV2S0i9zA3sSENXLEQcd4/3szfgCD5Da/Qfv5HCV2QZh8v
         KGEq49MIpUwk2NjU/Yml3LOOZ28gVw5sE65o1fAygnCzUR9EcWlW6vPNvdrg3hMY5S+h
         uEcA==
X-Gm-Message-State: AOJu0YyQkH8OtcfcRLYnj4QrJCH1m3sQIqy6+v66yQ3g0xZIHZiGEjHT
	dd2pSO5OWQol4iKTaHKQJuKoe3HegBz2Yy4iYbh9QW9oXdQRAMYJvWjyT+u/KfY=
X-Gm-Gg: ASbGncuEzRtpQWHc3oAit7i8o3Xt9zQ1K1vHBFlg7KC1YTuQpiFAQatunB9w8ulb7y8
	6vDtZ3d2Meh9aKn3pvWVfSAi/WjsdCTJ+R3JBqTrvLuepxCsgQ2qDdlAGnGnqX9wocGnnkSCj2e
	JAabMAmTfsIUFmJMETaD4x2Eo+/uCm77YJaA+zY0h+usQumcTBv15tvoUgRDq0LlftovypaZrFI
	4an+RL1Ha57rnp8/KW8sZaRb0RG8dK3i9rYt0IBY3c+KXTYyWmMDMz9FbrdEmvdxJ6DjnqsST+k
	LRZhPN8VLddY2b7diL/EOA6ywmA8X5A=
X-Google-Smtp-Source: AGHT+IFc0PFlmBTs0yiYIRChFimSXFc0fMrJjH08wxQTEa8CyvZUr9feUyc0ydWXUeKWKzRGQtrsPQ==
X-Received: by 2002:a05:6402:849:b0:5e0:8c55:50d with SMTP id 4fb4d7f45d1cf-5e4d6adc6a1mr4820536a12.14.1740734373208;
        Fri, 28 Feb 2025 01:19:33 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abf0c75feffsm256736766b.153.2025.02.28.01.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 01:19:32 -0800 (PST)
Date: Fri, 28 Feb 2025 12:19:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring/net: simplify compat selbuf iov parsing
Message-ID: <54e4c311-3c64-4bb1-afe8-ed1b32bfaeaf@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Pavel Begunkov,

Commit c30f89f1d08b ("io_uring/net: simplify compat selbuf iov
parsing") from Feb 26, 2025 (linux-next), leads to the following
Smatch static checker warning:

	io_uring/net.c:255 io_compat_msg_copy_hdr()
	warn: unsigned 'tmp_iov.iov_len' is never less than zero.

io_uring/net.c
    228 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
    229                                   struct io_async_msghdr *iomsg,
    230                                   struct compat_msghdr *msg, int ddir,
    231                                   struct sockaddr __user **save_addr)
    232 {
    233         struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
    234         struct compat_iovec __user *uiov;
    235         int ret;
    236 
    237         if (copy_from_user(msg, sr->umsg_compat, sizeof(*msg)))
    238                 return -EFAULT;
    239 
    240         ret = __get_compat_msghdr(&iomsg->msg, msg, save_addr);
    241         if (ret)
    242                 return ret;
    243 
    244         uiov = compat_ptr(msg->msg_iov);
    245         if (req->flags & REQ_F_BUFFER_SELECT) {
    246                 if (msg->msg_iovlen == 0) {
    247                         sr->len = 0;
    248                 } else if (msg->msg_iovlen > 1) {
    249                         return -EINVAL;
    250                 } else {
    251                         struct compat_iovec tmp_iov;
    252 
    253                         if (copy_from_user(&tmp_iov, uiov, sizeof(tmp_iov)))
    254                                 return -EFAULT;
--> 255                         if (tmp_iov.iov_len < 0)
    256                                 return -EINVAL;

This used to be:

-                       if (clen < 0)
+                       if (tmp_iov.iov_len < 0)

Where clen was compat_ssize_t but now tmp_iov.iov_len is unsigned.

    257                         sr->len = tmp_iov.iov_len;
                                ^^^^^^^
sr->len is an int.  So probably we do want to return -EINVAL for negative
lengths.

    258                 }
    259 
    260                 return 0;
    261         }
    262 
    263         return io_net_import_vec(req, iomsg, (struct iovec __user *)uiov,
    264                                  msg->msg_iovlen, ddir);
    265 }

regards,
dan carpenter

