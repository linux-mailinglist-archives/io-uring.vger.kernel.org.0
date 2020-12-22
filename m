Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3392E0549
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 05:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgLVELx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 23:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgLVELx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 23:11:53 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3F2C0613D3
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 20:11:12 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id m5so13143714wrx.9
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 20:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oYmxmoHzJrTHmTv8YyEYYTeqrKQpVgQfumOC6zyHT8o=;
        b=mM8+xe7VP1OtQObNO8FhTytjicYbA3Y0tS1eieyUCkSp5HeqlTVnLRHNP2TRlbduVX
         KbqWhB1BwLpKgYFUXBJl5Uq4KC58Fxk4/NZ3kCZki8MAp9YkIh584QFJEdJz0qHFBzgD
         l/sVv1Ry/qZ476rp9KQrtCzo/EQXKhRTlDaLb8ucUu6ZD51pFPf7rpcLpA7Bg3//tTMy
         5rY81pOlz5CvKwltxHwSBXluVcclhv1chMjsURWxOpLaU2KoSr2BdRMY26A978NaTlg/
         eIedLnftIn2+ItzKjcb/KhxldnW2K3szXHaA0skYM37ibeCayVZLV/EBZjeyp5WT+ag9
         9F1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=oYmxmoHzJrTHmTv8YyEYYTeqrKQpVgQfumOC6zyHT8o=;
        b=kvlns8okKCr7RKiiPJJIUVSa4HPWlSnWDeJ+WnD7w7w6i/joUoEYc/+smCrRHxJ9jt
         ckh7++JpBQT59mDSRF+JSjg3FAzSn/lq2N3cqBpI7s/JTvKJ0GEbZbvQnL8By1tJtAey
         AJQQTzE12zSeoGArEbBFcziisck+fGjhvGhF96Wsv/pgwsczbrJk+sjMvGLR8K3rWjf6
         eUDzc4bE9R0f1Bg1Ag1LXf3ay8/M/DRCuqzNinDif8lmQkdkZFHVZQIzLHu865ZajByq
         +0zzoJWcruH9r7K1CMk5aRgvNpk38J4O/Ti72fVnUDrreOQsQ76WGyT03uU6dshzMVvi
         s/Mg==
X-Gm-Message-State: AOAM531cbt67A/FHLE4AoKRxQvbg2SfSvtqAK8ZHFAWervOzncvgcqOI
        Jna9P9bXo1BK5F97jo2zk2kVKQH5uto=
X-Google-Smtp-Source: ABdhPJysXBZZ+ew00XNwcbn7KPpgW8ZyfnvxDuRmlSJTAvkJyNQIQ+wYMV/g9Xq/WFVPo8vtOOiQyw==
X-Received: by 2002:adf:ba47:: with SMTP id t7mr21514902wrg.285.1608610270948;
        Mon, 21 Dec 2020 20:11:10 -0800 (PST)
Received: from [192.168.8.148] ([185.69.145.158])
        by smtp.gmail.com with ESMTPSA id u66sm25745605wmg.2.2020.12.21.20.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 20:11:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com>
 <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
Message-ID: <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
Date:   Tue, 22 Dec 2020 04:07:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <58bd0583-5135-56a1-23e2-971df835824c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/12/2020 03:35, Pavel Begunkov wrote:
> On 21/12/2020 11:00, Dmitry Kadashev wrote:
> [snip]
>>> We do not share rings between processes. Our rings are accessible from different
>>> threads (under locks), but nothing fancy.
>>>
>>>> In other words, if you kill all your io_uring applications, does it
>>>> go back to normal?
>>>
>>> I'm pretty sure it does not, the only fix is to reboot the box. But I'll find an
>>> affected box and double check just in case.
> 
> I can't spot any misaccounting, but I wonder if it can be that your memory is
> getting fragmented enough to be unable make an allocation of 16 __contiguous__
> pages, i.e. sizeof(sqe) * 1024
> 
> That's how it's allocated internally:
> 
> static void *io_mem_alloc(size_t size)
> {
> 	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
> 				__GFP_NORETRY;
> 
> 	return (void *) __get_free_pages(gfp_flags, get_order(size));
> }
> 
> What about smaller rings? Can you check io_uring of what SQ size it can allocate?
> That can be a different program, e.g. modify a bit liburing/test/nop.

Even better to allocate N smaller rings, where N = 1024 / SQ_size

static int try_size(int sq_size)
{
	int ret = 0, i, n = 1024 / sq_size;
	static struct io_uring rings[128];

	for (i = 0; i < n; ++i) {
		if (io_uring_queue_init(sq_size, &rings[i], 0) < 0) {
			ret = -1;
			break;
		}
	}
	for (i -= 1; i >= 0; i--)
		io_uring_queue_exit(&rings[i]);
	return ret;
}

int main()
{
	int size;

	for (size = 1024; size >= 2; size /= 2) {
		if (!try_size(size)) {
			printf("max size %i\n", size);
			return 0;
		}
	}

	printf("can't allocate %i\n", size);
	return 0;
}


> Also, can you allocate it if you switch a user (preferably to non-root) after it
> happens?
> 
>>
>> So, I've just tried stopping everything that uses io-uring. No io_wq* processes
>> remained:
>>
>> $ ps ax | grep wq
>>     9 ?        I<     0:00 [mm_percpu_wq]
>>   243 ?        I<     0:00 [tpm_dev_wq]
>>   246 ?        I<     0:00 [devfreq_wq]
>> 27922 pts/4    S+     0:00 grep --colour=auto wq
>> $
>>
>> But not a single ring (with size 1024) can be created afterwards anyway.
>>
>> Apparently the problem netty hit and this one are different?
> 

-- 
Pavel Begunkov
