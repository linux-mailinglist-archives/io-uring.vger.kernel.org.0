Return-Path: <io-uring+bounces-6924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1115FA4D9D0
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 11:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0486B1893DC9
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 10:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612A61EE7AD;
	Tue,  4 Mar 2025 10:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoYaLr1N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13D3A8C1
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 10:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082922; cv=none; b=a57y5gNpZmd+x7DBeWoAjeHhZmSs5MA5oT9JFFrQPqA30yq3eBkaF9UGYyXDVn4ORaQABcRIch3ZmwoHY6fGT0ziiCSl0tTe5JHf3o3xUQYXgliebJ6svN0IAMkv1563zqTx0aq7JeT22Ei1ZlyL7TeHwaBI141d328L07HGfL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082922; c=relaxed/simple;
	bh=y23omZl1oTPpnK8Ze3Wv+s964K0ktUg0ybsxjg9yhBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qxRcw1YJV+qTfQDN7xSgIgH1uuDEfyFqQWOABu4klJQ1km3peL7zOPSIatPEhsrPjLitzd8CvYdUg9TsHW6dpXUlOqxDU7ohJ0ylnA59c7L4MPyqKmMSW4yMmeXzub+d6FgNk3N7g8qHOUv+JHUgTydSek63XRdPFybBESlUw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hoYaLr1N; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaedd529ba1so632591466b.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 02:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741082919; x=1741687719; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6p/Z7vwXB2WxuC0MUMaKjJ7mTadaCP2JA+eGjxqb1pA=;
        b=hoYaLr1NHEo1nE8jSCts9BP8/mro1ACKq7S0lkwSyMqQ2f4cHY9AYd9PIO67ANBpPU
         4+on3X2ibVa4CAGfORSd64Hy4GwMAI4bPHbn5DtIF9F3QpITONRWAa+hBTM5L4Jun1iT
         MKHCKfZeO4aeyF/wCbA3tsPloNy67c8ka90cyHn8nD9IcrU5ZsrwuScHROJkkWMTGonp
         2kyKABR/E08565ani5CQAvam9fnDf0lHTozZe6LU1a17soEk503NB1zwN3mXlZkXC96a
         09HNXEFgIYuJfHkE7Q/8qtdJ+suPWjw05swl13yBzh29jKRTKaYPyvKrgai/O/CvKddy
         lGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741082919; x=1741687719;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6p/Z7vwXB2WxuC0MUMaKjJ7mTadaCP2JA+eGjxqb1pA=;
        b=NAsWmtjwpNsoq3EaD2fgLwWtojtGVv00Quq4VYb1ZmiuIzU8teFfEozJJ3lhB5oqNR
         HXRSw87AU1QRhcyCjhYSLXPLIws6TcxVS8NehaXh83cqSFAOm8NQSLt2b7hlEpKAFSRO
         DKWWs0z899uzfz7H+/bMEiASnZFHTyB/5Sv+Pvv19OxL/1uUjGDsM5hSlbuTdSlyNVOY
         qXlKd7QVagMc/axGU3ev0OUdez2G7gGNSe2UcLahe4cidzJyISV6utDCtf/CrPSYtliZ
         Nekn0Yrabvg6vB0oJW5mv/kBh4FaUpF2kFc+5NhctiygVdPRpyxqyOexdDA4gblOuy3H
         3BGQ==
X-Gm-Message-State: AOJu0Yx4A6/6UEjrjC/WyTIPATBKJ/Y56klGIe/UakZyGjZj2DJ504kL
	H6Q0aImD5yZAbMVa2+82Y8PZxgncspSuRQBa+Q19pNaPtvzYD1u5
X-Gm-Gg: ASbGnctpoxAcoRy7hX/5+uGlCZPgb8SU/KWzQeB7tcgFy7fthFFFOh+iEByBnb2yI0g
	vrvh2hk0JIqHvRSlED9Mdkh0L15x/ghpW0oDmqyyEWzfC2YEIzRqyHcZOKk8mmHPp3KKRuygAuG
	db4SW8Mi0km4PsxBf51Xvk2PuSV4Bj+UBKr1415wQDMlLB9b1rAt6gHt8CQd2tryYa+IOrmeyme
	r/8hfTRPeww6UYSL1W75oNLJ0ZYM2fSzHQmtAx7DeREBdubaWxLgrlb6amVya6FmLE1UjN2UyqA
	ZnSCyLUuWIyFMFRmNMJP1ec88rhZkKgDlVkfGg3z40FPtre51/yWlMGGiC1Br3kgCZv333sT6xn
	aNQ==
X-Google-Smtp-Source: AGHT+IHN1WzwxoxdUx1wt4D04pKuuPHva9XSukEYEMYmPuJ0S7K3cqEc0TjRrTk0hbOLCh9h2iI9EQ==
X-Received: by 2002:a05:6402:1ecf:b0:5e4:ce6e:388b with SMTP id 4fb4d7f45d1cf-5e4d6ac54a7mr46712020a12.6.1741082918725;
        Tue, 04 Mar 2025 02:08:38 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:87eb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf7b3882dfsm299274166b.143.2025.03.04.02.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 02:08:38 -0800 (PST)
Message-ID: <ae597b1e-a389-469f-88f5-503bdfecc029@gmail.com>
Date: Tue, 4 Mar 2025 10:09:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] io_uring/rw: implement vectored registered rw
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <444a0ab0c3dc6320c5604a06284923a7abefa145.1741014186.git.asml.silence@gmail.com>
 <CADUfDZrNCzE=X5tSOsa9rBqop-TW3Kw9oHj8u+YDxYJXGyw5uA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZrNCzE=X5tSOsa9rBqop-TW3Kw9oHj8u+YDxYJXGyw5uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/25 23:01, Caleb Sander Mateos wrote:
...
>> +       /* pad iovec to the right */
>> +       iovec_off = io->vec.nr - uvec_segs;
>> +       iov = io->vec.iovec + iovec_off;
>> +       uvec = u64_to_user_ptr(rw->addr);
>> +       res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
>> +                             io_is_compat(req->ctx));
>> +       if (IS_ERR(res))
>> +               return PTR_ERR(res);
>> +
>> +       ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
>> +                               uvec_segs, iovec_off, 0);
> 
> So the iovecs are being imported at prep time rather than issue time?
> I suppose since only user registered buffers are allowed and not
> kernel bvecs, you aren't concerned about interactions with the ublk

It's a question of generic io_uring policy and has nothing
to do with ublk. Thinking about it in terms of a specific
user wouldn't be productive.

-- 
Pavel Begunkov


