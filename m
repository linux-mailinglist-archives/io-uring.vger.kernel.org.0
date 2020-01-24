Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFFF148C64
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 17:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389701AbgAXQl0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 11:41:26 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42504 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389693AbgAXQlZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 11:41:25 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so1368827pfz.9
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 08:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c1R1Akiox3bJ6VHzcuHZodyEN8jm8d8TcW2t2/c1oy4=;
        b=Cwpe5AXR6JHkEA7lLoqrP4CWfur5Tzx/phrFfsQT6GVIx9E7On+vksajHC6a2jccEV
         PstvxGWpjH6Ju/GLXlDx9a/w8/CmbBCEEXKJYUvcgqvD/yjX5TXKhu3Ofl/NHVPYagoo
         NtcV+9KtcUvkqU1/9yp1y6JSSz3BgXhr+W7RU8uPV9fBVR1MWwoP28zjB7ggTZgu2UVA
         AHnClAicCTYkwIZMcXTYjdG8Zw5mWDF/zMfV380zH8BQoG9Gh39114cXrzhaAvqZRst2
         vJIGlZZha4YKnrNf3UafywyZaP3/9FgPnNHUXUoCtYpSFl2Cjw8p8QS3LMrUgwnnvS8G
         DQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c1R1Akiox3bJ6VHzcuHZodyEN8jm8d8TcW2t2/c1oy4=;
        b=L0UefCmcL3ouAQiI0C+5uZO+eT3VhFiM7Vau8laA1uEIE0UID/nHlAVhO5ZNzxe2BN
         /ijumMirbKF4KF5TaV2f/y4fe5CEVWSQO1swCIwuogv5hZg72tUGfnztXo1WZjTksmzT
         3Dlge2Qx31Mctf7aLdnYucIPYMNyEfv4rafcls0CBNXTm0THvR4s1dv6bI08cYTNxrqo
         pUP2KL9AyI9H23cvuhdrksDAI7jicLoNOCPmpfVieGYBxiNmHKTvzCKKbLJ5xfMYLpMV
         rkNN83VOOgGEGMWp5M1vMZ0sBBMltbp5CYBY2VDXrYgKBDTB3oeVCzn2TMly/DPd+8FJ
         7c1Q==
X-Gm-Message-State: APjAAAVkwEVj+a4/KjXos7gEKSaqnYrHTJiNoxoh4u7n6xJ4ciTWjvqn
        O0xje4Zp0rkqEXGJwxnXzcJbQosyves=
X-Google-Smtp-Source: APXvYqyc5uaaTBJCaHm4w6Up6UhykHvOVWtR+Ftl0Nlg61KrBCMRDDl+Wva6RctRQbX8AURQOR9zmQ==
X-Received: by 2002:a63:313:: with SMTP id 19mr4897301pgd.7.1579884084792;
        Fri, 24 Jan 2020 08:41:24 -0800 (PST)
Received: from [10.47.243.41] ([156.39.10.47])
        by smtp.gmail.com with ESMTPSA id c15sm7452180pja.30.2020.01.24.08.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 08:41:24 -0800 (PST)
Subject: Re: [PATCH 3/4] io-wq: allow lookup of existing io_wq with given id
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <20200123231614.10850-4-axboe@kernel.dk>
 <c3e67265-dff9-a832-090c-6110dd4ef6c3@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <861adb23-dace-9117-7e8c-535075077eea@kernel.dk>
Date:   Fri, 24 Jan 2020 09:41:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c3e67265-dff9-a832-090c-6110dd4ef6c3@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/20 2:54 AM, Stefan Metzmacher wrote:
>> +/*
>> + * Find and return io_wq with given id and grab a reference to it.
>> + */
>> +struct io_wq *io_wq_create_id(unsigned bounded, struct io_wq_data *data,
>> +			      unsigned int id)
>> +{
>> +	struct io_wq *wq, *ret = NULL;
>> +
>> +	mutex_lock(&wq_lock);
>> +	list_for_each_entry(wq, &wq_list, wq_list) {
>> +		if (id != wq->id)
>> +			continue;
>> +		if (data->creds != wq->creds || data->user != wq->user)
>> +			continue;
>> +		if (data->get_work != wq->get_work ||
>> +		    data->put_work != wq->put_work)
>> +			continue;
>> +		if (!refcount_inc_not_zero(&wq->use_refs))
>> +			continue;
>> +		ret = wq;
>> +		break;
>> +	}
>> +	mutex_unlock(&wq_lock);
> 
> Isn't there a more efficient ida_find function in order to avoid
> the loop, which won't really scale in the long run.

Yeah that would be a lot better - I initially just used a sequence
for this, but since I'm now using ida, might as well use it for
lookup as well. I'll make the change.

-- 
Jens Axboe

