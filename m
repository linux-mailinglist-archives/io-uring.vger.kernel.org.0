Return-Path: <io-uring+bounces-9859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D09B8F712
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 10:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BB721726BE
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 08:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A672F6576;
	Mon, 22 Sep 2025 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHvfBV69"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F71E271443
	for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758528864; cv=none; b=P2yKZ7hl5FA8J7a9Iu/WkqH3FsNGFeDgk3PJqPfOxCQZhyzTcm87OTCX4cUuvmrAf45n+baj5O7DLBg2JktXMa5ND/KzxI5OTICixgJQj7Hjqtu5oBRZnyyE8U/lahAb3G/WAjjAWZ2QvlUamVzgVv+PWOK+jgKkpwXoh45R4oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758528864; c=relaxed/simple;
	bh=5V3RigcVBywwMMrxZeLVCsYq6OMODbrbfyVEjxUekq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERcBHsjJ8PSmZ0hzzjUY+Cg0yGHtyf731lm25xuuSNA3aVGR4s5EcGzvUFttVxwupLg90UxjnHtxjVR4OG3NgYJboKJEPWUm2wbhq4j2PzzrUMncgD6qC/NMzv0ZIOC9k7mdc/zkkYDypNiEHqGaMo+A4lnhzG4msMHENPLfGAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHvfBV69; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so2851041f8f.3
        for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 01:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758528861; x=1759133661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=i6l6pMT6zRaik6/aOVmQGtebABX2xIAli+ct8xSkwRU=;
        b=BHvfBV69MI7gU1dsauP8NrfzgUGDoy56YIZLc98y3ytbUJ0IretZIEcRHom+meyCZs
         5zPJSJ5Qft+pBkH/AhzJCwfHzGkjRHxzvlYfBVVGBFwky9GBybI1ztxjVsCuSaNfx9FQ
         pTOUBfuH9cykXTByxwfqdtj6J1sn35jWclj7sJhmbicM0kpmNrqFFgufFbo6E8uD7zUj
         DiISbBkKkp6odhOS5i+ze7WT0rvHuhGX2Y8TXAOJMLHLouyAGqZRd/K02bzcd1j5iqT3
         IHMFSFdTcv7aq1KUUOBgAO9eQEg6B3nw1NdIzjpjziFnTJOzfplP1+Dnz2CTB9cvOMV6
         u3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758528861; x=1759133661;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6l6pMT6zRaik6/aOVmQGtebABX2xIAli+ct8xSkwRU=;
        b=Y95bNK3haLtowfcMkyNLbEP2SbxNvInMU846Af22bTMMH+qpdn0UVyxr+BhE7V2Mwx
         QWvHUNZZjrB08ZAeu51xz3QXhz2oeudEVnJqbEwRUtOmJZtrQieSyhJKzZ5/Ojjc/2Rm
         musNyVCWpyOe8Gu1NjKnN2J66Pj4OmRQfCrmWrX3nF+c7dXWFLi07hDcCWVotPosh/Nx
         OwJdUos9Yprzy86fnGyr6FucgdOalQnoWETOgjgmxk5RicUVP6OabrLMYUhmEgnGdnOy
         p+EDZdULc5juo/KNYPtT4HuON1FY4sMW5Y7dNeQ9hJKjHoqeqYUG8dHwIqBWs4uqpiOP
         737A==
X-Forwarded-Encrypted: i=1; AJvYcCVlpkUwFLM1ZppAGPonkYJft4MieIaD2s4j1sREyDCXB0iyUhp+H1q+FYSZnOK9T+q2EdpnI8OMIw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl4Ung7b4WsU0ZHGL7YG49bxdirZzyJmAjvEmr1pUBq5X50f2b
	DRCEZShBL3ZsMshGVhJ8t88Id1+0wKXpYJ8LFjuHBwKroP9B6bHUa3f3n21Tfg==
X-Gm-Gg: ASbGnctensvKvsFGoLsLxJryMnnJTUUDzKPYM+yrIkVDWuct9RNba+ISBy1uD3MBO7g
	FPqDmEX33DR288BtHHCvJOE07gMkGLpzZug2EOimfWWtv+gjp1o9poYL1d8JM5qi6RCctNjjVxb
	PPoP9UEj6upXTDikGrzio4z9vXTexLhGtUsUqh2tLpQsecvbaVJyJtpC9e+A0Hi7uMZ/bJ3MMgN
	6wZnkw+eQ0x16l77tI5jJe2KcOeGtEGCWIHm/jXEOt4p1I0Vl61KCZzbh78I16weGT419adm/ln
	SbKmftdwvWblv5md1eiYUxxH3A6VJFF3dM/0QNoSPdJbQHDABGnnVyBN3iLmX7GLLRtj9wCRSDO
	ak55nBbq9o4f7IxxbdVmrMVwOZorMSVhuQbprVBKa
X-Google-Smtp-Source: AGHT+IFoCebX3ZcMoCJHnUxvCNxAQ4+PQzNxqGcohWqjqqCqboVNgcZESu4rAQPh6I6BtPsndhfhwg==
X-Received: by 2002:a05:6000:2486:b0:3ed:f690:a390 with SMTP id ffacd0b85a97d-3ee8481fdffmr10330964f8f.40.1758528861098;
        Mon, 22 Sep 2025 01:14:21 -0700 (PDT)
Received: from [192.168.100.117] ([41.90.209.136])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07408258sm18981936f8f.19.2025.09.22.01.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:14:20 -0700 (PDT)
Message-ID: <dcbcec93-0dd1-4874-8a51-dfd53af2db03@gmail.com>
Date: Mon, 22 Sep 2025 11:17:20 +0300
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Yang Xiuwei <yangxiuwei2025@163.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, Yang Xiuwei <yangxiuwei@kylinos.cn>
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
 <152d553e-de56-4758-ab34-ba9b9cb08714@gmail.com>
 <CAAZOf24YaETroWiDjmTxu=2b2KVTxA1+rq_p5uxqtJqTVBfsJw@mail.gmail.com>
 <CAAZOf251fh-McW=7xdEQiWyQ-XfOC1tRTUnyTD4EHVaLG-2pvA@mail.gmail.com>
 <1e5ff80d-73f8-4acd-8518-3f10c93b4e40@gmail.com>
 <CAAZOf250CqN67DTXF+74-8q3JbRCAuaW=XbrxqoNaq09RNUOJA@mail.gmail.com>
 <a85ea039-9cf6-4ea2-b5f5-3049c27fe187@gmail.com>
Content-Language: en-US
From: David Kahurani <k.kahurani@gmail.com>
Autocrypt: addr=k.kahurani@gmail.com; keydata=
 xjMEaGeKGhYJKwYBBAHaRw8BAQdAszIMLhg+/ak9qXq8KAzkbW0Wn76Ik8vG3gOFzjwO+c7N
 JURhdmlkIEthaHVyYW5pIDxrLmthaHVyYW5pQGdtYWlsLmNvbT7CiQQTFggAMRYhBCqMeHNe
 AY+307gMwS3KKQVhZOfpBQJoZ4pOAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQLcopBWFk5+mc
 qgD/b4VPmj7Q3mAiDtNwVMAUyj+f4iDcs+ahBtvluW4aQTAA/0ndHW2hl+tAeUTO20C6fg7d
 lwhpnynmul71iDSihPsCzjgEaGeKGxIKKwYBBAGXVQEFAQEHQERbQr4mQLC86ahgv0gyoYVn
 kMsnM/zWn14tAzgsGYN2AwEIB8J4BBgWCAAgFiEEKox4c14Bj7fTuAzBLcopBWFk5+kFAmhn
 ik4CGwwACgkQLcopBWFk5+mc1QEAsyb3VKLetFiapyqfgaBsWx8bUOCY103BvFT/vQ56B9QA
 /2XooZTHO0DZ9JLt/9pRsXJpTRKsAGjKQGIspAW8OlYP
In-Reply-To: <a85ea039-9cf6-4ea2-b5f5-3049c27fe187@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/22/25 10:52, Pavel Begunkov wrote:
> On 9/19/25 15:28, David Kahurani wrote:
>> On Fri, Sep 19, 2025 at 5:14 PM Pavel Begunkov 
>> <asml.silence@gmail.com> wrote:
>>>
>>> On 9/19/25 12:25, David Kahurani wrote:
>>> ...>>>> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
>>>>>>>
>>>>>>> diff --git a/io_uring/notif.c b/io_uring/notif.c
>>>>>>> index 9a6f6e92d742..ea9c0116cec2 100644
>>>>>>> --- a/io_uring/notif.c
>>>>>>> +++ b/io_uring/notif.c
>>>>>>> @@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, 
>>>>>>> struct ubuf_info *uarg)
>>>>>>>                 return -EEXIST;
>>>>>>>
>>>>>>>         prev_nd = container_of(prev_uarg, struct io_notif_data, 
>>>>>>> uarg);
>>>>>>> -     prev_notif = cmd_to_io_kiocb(nd);
>>>>>>> +     prev_notif = cmd_to_io_kiocb(prev_nd);
>>>>>>>
>>>>>>>         /* make sure all noifications can be finished in the 
>>>>>>> same task_work */
>>>>>>>         if (unlikely(notif->ctx != prev_notif->ctx ||
>>>>>>
>>>>>> -- 
>>>>>> Pavel Begunkov
>>>>>>
>>>>>>
>>>>
>>>> This is something unrelated but just bringing it up because it is in
>>>> the same locality.
>>>>
>>>> It doesn't seem like the references(uarg->refcnt) are well accounted
>>>> for io_notif_data. Any node that gets passed to 'io_tx_ubuf_complete'
>>>> will gets it's refcnt decremented but assuming there's a list of
>>>> nodes, some of the nodes in the list will not get their reference
>>>> count decremented and
>>>
>>> And not supposed to. Children reference the head, and the head dies
>>> last.
>>
>> I am not sure about the mechanics of this. This is only based on
>> analysing the code but it seems, if a child node gets completed, it
>> will pull all the other nodes in that link by jumping to the head
>
> It'll put its reference to the head, but nothing is going to
> be destroyed until the head refs hit 0.


I take that to mean there's some code elsewhere that also interacts with 
these references otherwise just based on this code, it seems like notifs 
always have a reference of 1

Because I don't have a stacktrace, I will leave it that.


>
>> node. But, I trust that you know better :-)
>>
>> What do you mean it's not supposed to? All the nodes eventually go
>
> I was saying that the head isn't supposed to put the children's
> references, it goes the other way around. Children have refs to
> head, and everything is destroyed once the head is put down.
>
>> through 'io_notif_tw_complete' to be queued back into request queues,
>> if any nodes whose reference was not handled(all nodes get a reference
>> of 1 at allocation) goes through the method, then the warning will
>> trigger.

