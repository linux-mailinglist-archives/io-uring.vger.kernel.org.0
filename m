Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EA079C174
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 03:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjILBMW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 21:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjILBMJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 21:12:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E95E13AFC
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 17:48:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c0efe0c4acso8931165ad.0
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 17:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694479592; x=1695084392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zw93quJojhjYiZD6YayYZa6PTcQtDCvV9PJhOu8LsU0=;
        b=UctwPjI/dzaCEMNgxPuEoMoiZuzmkynnxtWa2t8Rf96CU5iMbGWDlguDR8Mr1GWHYJ
         DtPRKQ4Id2TZVN8BuOKhpbAOr3RRzUSYNaWbRF4xmzDMgshrWN1l3HCLY69+5TjcO+YC
         ZhIH2F5TzAV4JNAsKDUAAx4NKVq7z4+M4b8JFpUBTiCdhTsT3ylpNdgiyKTpwsG0uyVs
         9r+Ma8zx7iFk8k5MlSG/P1+9VP0KsE1GQM7kbZ72+3J3rv55e6hlM38xOoGQWmi/X4VG
         seqbw2rMGsMlR/TgGcf3nMFfb9PqLFO6upnMgtpfAxQQwTyO+NBlG6/PLhj7jCprDTIY
         hMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694479592; x=1695084392;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zw93quJojhjYiZD6YayYZa6PTcQtDCvV9PJhOu8LsU0=;
        b=BRopH+oShsVt60mV3QqJTYY5aQm8EIHw/TSIfB4v8FywMA7qJi9Ox3pyNb1lCvgrU8
         +oAQO8uFMt+DGQxO3dI5adzJOl78FPqzb5xiP9PM+0CeCwMlWKlkHDZevQ3GPi6Rl+lU
         Nni2QKH5jT2jL27tzB2Xe9Q4bhmiYX5Vzd7Nksu6JFvTYHVkhhs+q8ij48kVWbJXcjWV
         y7l6jcKJo6P2STRMckjiAbnIH6LwCvLvwYxEYVg1p4pl5UDMIpMcvmp/hGo0k5hXBavx
         mO5/RpYczml8hcnJnhLy9VkKoX5Btzrp//veyFaNsugLEaT496vSPcKmWjFCC0bI9yPh
         biPA==
X-Gm-Message-State: AOJu0YyuGpaXL0o47PpGbImE1qOfFVbg6PkXUBloaJfvQygKsK1DgUYc
        fTQDqoKASfa5i1uAewugTH9EkwLdVriwnMZJ4vRAYA==
X-Google-Smtp-Source: AGHT+IFUM92An5l1JwfPJCFn5cZWEy7qaOfA2PveT1AWWW0WR/VAFiKmjSxe7sCGNAb+/aePayGRdQ==
X-Received: by 2002:a05:6a20:8e19:b0:137:3eba:b808 with SMTP id y25-20020a056a208e1900b001373ebab808mr12125580pzj.5.1694479592040;
        Mon, 11 Sep 2023 17:46:32 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id cl8-20020a056a0032c800b0068fb783d0c6sm3408405pfb.141.2023.09.11.17.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 17:46:31 -0700 (PDT)
Message-ID: <56f52ace-0e6b-46c2-83c1-98b54cf5bd0b@kernel.dk>
Date:   Mon, 11 Sep 2023 18:46:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20230911204021.1479172-1-axboe@kernel.dk>
 <20230911204021.1479172-4-axboe@kernel.dk> <87o7i85klx.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87o7i85klx.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/23 5:57 PM, Gabriel Krisman Bertazi wrote:
>> +int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	unsigned int cflags = 0;
>> +	int ret;
>> +
>> +	/*
>> +	 * Multishot MUST be used on a pollable file
>> +	 */
>> +	if (!file_can_poll(req->file))
>> +		return -EBADFD;
> 
> io_uring is pollable, so I think you want to also reject when
> req->file->f_ops == io_uring_fops to avoid the loop where a ring
> monitoring itself will cause a recursive completion? Maybe this can't
> happen here for some reason I miss?

I saw your followup, but we do actually handle that case - if this fd is
an io_uring context, then we track the inflight state of it so we can
appropriately cancel to break that loop.

But yeah, doesn't matter for this case, as you cannot read or write to
an io_uring fd in the first place.

>> +	ret = __io_read(req, issue_flags);
>> +
>> +	/*
>> +	 * If we get -EAGAIN, recycle our buffer and just let normal poll
>> +	 * handling arm it.
>> +	 */
>> +	if (ret == -EAGAIN) {
>> +		io_kbuf_recycle(req, issue_flags);
>> +		return -EAGAIN;
>> +	}
>> +
>> +	/*
>> +	 * Any error will terminate a multishot request
>> +	 */
>> +	if (ret <= 0) {
>> +finish:
>> +		io_req_set_res(req, ret, cflags);
>> +		if (issue_flags & IO_URING_F_MULTISHOT)
>> +			return IOU_STOP_MULTISHOT;
>> +		return IOU_OK;
> 
> Just a style detail, but I'd prefer to unfold this on the end of the function
> instead of jumping backwards here..

Sure, that might look better. I'll make the edit.

-- 
Jens Axboe

