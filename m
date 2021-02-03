Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFB130D937
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 12:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhBCLyV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 06:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhBCLyS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 06:54:18 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6856BC061573
        for <io-uring@vger.kernel.org>; Wed,  3 Feb 2021 03:53:38 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id b3so5769528wrj.5
        for <io-uring@vger.kernel.org>; Wed, 03 Feb 2021 03:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DXnJRhRUAlT5DtrrBMC5mtD3w/jhTm/Nj0/eRM0/yss=;
        b=ao3S6VUfu47wZ/AVdnfigxx2kLTVFLaamo/0zSwynB8vDbLOUMoKnPNBKCeNIf+mrm
         xe/eGughiLOIdUCQeDdAs+xHwHuI/n1JPyoMd5qufspDhjpOBHHmOq3fDIsdUKFxJX33
         wpLwvKvufqoCPqRDRqttZKYo4sErP12etMFq50Sp++rMLSXCw5uO9e4NmQfU4zAfeoSL
         L+MVdTXbP1Anc/uabgw7ItzKCUWQ2Gb3BAUImmUnd0O4tR/BIPDDplcwQmdKfNN+3sF9
         JCp430/hS23vRItjAZqod51GhlZO/uNnhF8Fq6d+mySiWyRMkbRN6kj7iKy/xliTKwLF
         6M+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DXnJRhRUAlT5DtrrBMC5mtD3w/jhTm/Nj0/eRM0/yss=;
        b=nZqdra1b2PvPqTUAnf9e5/YpYu/E5TfdCU80ZuLpQJw6EkII5ka5KUFv05YTwhkRX2
         B/EBM/FGNUFd5cCD7cdeUjEF/PyVt7riqlWs0vl2yVG2/nIf868K2VU1SDwS2EpWjLS4
         b37Mvx0++6io0v3MaNo30dRdxIukdY0iu0NvKRyhf2dP4acGDzeJXBRIUld/FyttV37s
         ap0xWCG1TxCf5nAQB1OE+VR8DglZrCuRrOxzniIMXemuyR8zBiiwwFCrlN4M4otNv51d
         CqGr1gXeNuPSr1y90Tli4K4bw6++uXwL7AFaTYjSIgNr35Evf8+hhOcftY+chHgjNepu
         6XOA==
X-Gm-Message-State: AOAM531SnL9SKIY9XnQdQ1DqZeU3gwaY1SPTydkUHZ7RUpheCUejIMbv
        ZIdfw+Z4Tyawl2+YtNHRi31g/XOfFk0=
X-Google-Smtp-Source: ABdhPJyOUYLXCf/lL3iP4+lTAottzqjlHanW6YB89Kx8AxbRLOYxxUd4padQ8qhf2gwVbV5Vz5+poQ==
X-Received: by 2002:a5d:4988:: with SMTP id r8mr3150561wrq.26.1612353216851;
        Wed, 03 Feb 2021 03:53:36 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id t205sm2500004wmt.28.2021.02.03.03.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 03:53:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
 <8d75bf78-7361-0649-e5a3-1288fea1197f@gmail.com>
 <bb75dec2-2700-58ed-065e-a533994d3df7@gmail.com>
 <725fa06a-da7e-9918-49b4-7489672ff0b4@kernel.dk>
 <5c3d084f-88e4-3e86-3560-95d90bb9ffcd@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
Message-ID: <39bc0ff3-db02-8fc7-da5c-b2f5f0fc715e@gmail.com>
Date:   Wed, 3 Feb 2021 11:49:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5c3d084f-88e4-3e86-3560-95d90bb9ffcd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/02/2021 20:56, Pavel Begunkov wrote:
> On 02/02/2021 20:48, Jens Axboe wrote:
>> On 2/2/21 1:34 PM, Pavel Begunkov wrote:
>>> On 02/02/2021 17:41, Pavel Begunkov wrote:
>>>> On 02/02/2021 17:24, Jens Axboe wrote:
>>>>> On 2/2/21 10:10 AM, Victor Stewart wrote:
>>>>>>> Can you send the updated test app?
>>>>>>
>>>>>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
>>>>>>
>>>>>> same link i just updated the same gist
>>>>>
>>>>> And how are you running it?
>>>>
>>>> with SQPOLL    with    FIXED FLAG -> FAILURE: failed with error = ???
>>>> 	-> io_uring_wait_cqe_timeout() strangely returns -1, (-EPERM??)
>>>
>>> Ok, _io_uring_get_cqe() is just screwed twice
>>>
>>> TL;DR
>>> we enter into it with submit=0, do an iteration, which decrements it,
>>> then a second iteration passes submit=-1, which is returned back by
>>> the kernel as a result and propagated back from liburing...
>>
>> Yep, that's what I came up with too. We really just need a clear way
>> of knowing when to break out, and when to keep going. Eg if we've
>> done a loop and don't end up calling the system call, then there's
>> no point in continuing.
> 
> We can bodge something up (and forget about it), and do much cleaner
> for IORING_FEAT_EXT_ARG, because we don't have LIBURING_UDATA_TIMEOUT
> reqs for it and so can remove peek and so on.

This version looks reasonably simple, and even passes tests and all
issues found by Victor's test. Didn't test it yet, but should behave
similarly in regard of internal timeouts (pre IORING_FEAT_EXT_ARG).

static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
			     struct get_data *data)
{
	struct io_uring_cqe *cqe = NULL;
	int ret = 0, err;

	do {
		unsigned flags = 0;
		unsigned nr_available;
		bool enter = false;

		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
		if (err)
			break;

		/* IOPOLL won't proceed when there're not reaped CQEs */
		if (cqe && (ring->flags & IORING_SETUP_IOPOLL))
			data->wait_nr = 0;

		if (data->wait_nr > nr_available || cq_ring_needs_flush(ring)) {
			flags = IORING_ENTER_GETEVENTS | data->get_flags;
			enter = true;
		}
		if (data->submit) {
			sq_ring_needs_enter(ring, &flags);
			enter = true;
		}
		if (!enter)
			break;

		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
					    data->wait_nr, flags, data->arg,
					    data->sz);
		if (ret < 0) {
			err = -errno;
			break;
		}
		data->submit -= ret;
	} while (1);

	*cqe_ptr = cqe;
	return err;
}

-- 
Pavel Begunkov
