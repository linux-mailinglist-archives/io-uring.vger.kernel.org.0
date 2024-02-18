Return-Path: <io-uring+bounces-622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4E0859703
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 14:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 515BE1C208CB
	for <lists+io-uring@lfdr.de>; Sun, 18 Feb 2024 13:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4DA65BD5;
	Sun, 18 Feb 2024 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jaeR2EcQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FBD6BB51
	for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708261243; cv=none; b=YYNZb1yOXmTzR1dVuzXyn3d325pWwhUYo5IbGIjAWYUKPyZ2TO2gZx3ukCzox1OHzZOy2lGVwtTdCOuBfyC73HJ2HsWDlkVjfMvevr42kO8eOZiXTbya16W3bTjaWJRNvC0kbFsHTzcGFVWySs9gG6iTH2PyzMQZo6NiqcSMzPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708261243; c=relaxed/simple;
	bh=8OEULQsbJfHqfkXaJy2htFuiEY9YhAYuhxxZlhozNTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oZi7p1Zg93lMzcKzl4a2PXUcXojbSEz3V9+Zqdc8lwFpoZH8Iet/k7WoTDcNQkNRMA83RfNDqchELhCV0MRxVN0A4RKMBOMWkhcGwOMQxsq9mquZrCG9UOQPrFcA55xAGfjzXP2QjNk7GEPZwKDGkoGKxPSRdK+AhRmxew44/xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jaeR2EcQ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29593a27fcaso987880a91.1
        for <io-uring@vger.kernel.org>; Sun, 18 Feb 2024 05:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708261240; x=1708866040; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RodByd/HG8871Mn03XNPX9N8h91R/e6bdUV6nucU/s0=;
        b=jaeR2EcQ0f5a9YEbXLM2S3PBeD6qUrOzBLPfLvJIyCrUKvJsRNPRAorn07isKcJaSk
         rEZtRHw/3E18xowGleJuM3z+sHblj0kAzRDBMfhoRQS0EIPpagv9pKhToYmX5zjuC0Sv
         Ulrx0cJosMpltzYOlmjJJ6cG7u88fzha6zCVG5/VJssUAHloSD51ggXN4t4CNVQCOaV2
         d4DexksgWMvu+pwOwRdgTXEcig/nHtXixLgPBJGa8ZLOCl+3CKQeMLXhV3TUdBoaGd96
         c2MyaKRnqAyDttrcLGFHI1SVrY3U2mJdrSjggoDLR8gGLAXc7F/lrmvZKyMsw4eWZWKZ
         5Heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708261240; x=1708866040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RodByd/HG8871Mn03XNPX9N8h91R/e6bdUV6nucU/s0=;
        b=htRXbrUOW0DMONrkfIlqr1Sf2mr4S7eaUisJ9U15Uy2F5EDKDJVKfgOcjmY88XnbjO
         iUrSsOHybYW9ZW/f0WYAUaLMNTYfz5l6XTe0DAo2GWFHWhYARCyU7CvOGuIiQxhHd8oD
         84bTDDpm1d6+pLaeCd2u+YneXDqTTNjFRuUQ2yLFK4PDjSsuso/+m75r2YsJl25c3Jg8
         wujYod0Vpi6CQVR8W6cBshkTq32155OytntXctZCLXolf2YC38SMJgw94+5dR8/aihTU
         Q00teTgFb+Jj4yDpqv94uK+M8bp2NfXmWbKY+ZK4Y1B8a/IrCrYnUFeOrbRbqDVIb7wE
         7XHg==
X-Forwarded-Encrypted: i=1; AJvYcCV0lLbC3xA9SBd5Oe/gUo+SZLW5jHHDHA0vuq0uWcsLyMwTVzYJzjI1H0komCuLnAqlDbMJhmKlPpfLSYXG8pK3AHE9z8zx1nI=
X-Gm-Message-State: AOJu0Yxz2g6TtbTIr31R2njnfWFbpsja2jedNpmDZ7NCkVifptznYeFO
	FEsQYsjYNV4t4+s/WPF4ObIWOfB7NBo/SG2O43Wb2dhNTWWucEO1zq7I9IDdmWo=
X-Google-Smtp-Source: AGHT+IF/9MngS1gHDj2UfEL3koN32okEsAusVWjfdNuL59cquLXw8MkmbJVoODuiE5/zseUhcHfANA==
X-Received: by 2002:a05:6a21:999c:b0:1a0:9abd:2801 with SMTP id ve28-20020a056a21999c00b001a09abd2801mr3451853pzb.3.1708261239954;
        Sun, 18 Feb 2024 05:00:39 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 18-20020a631052000000b005d553239b16sm2906268pgq.20.2024.02.18.05.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 05:00:39 -0800 (PST)
Message-ID: <aba32b4b-9fb3-4d84-bdc0-633d34cf1234@kernel.dk>
Date: Sun, 18 Feb 2024 06:00:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] liburing: add script for statistics sqpoll running time.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <20240206024014.11412-1-xiaobing.li@samsung.com>
 <CGME20240218055959epcas5p2ac436be88fecd625f072c78ff77610ef@epcas5p2.samsung.com>
 <20240218055953.38903-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240218055953.38903-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/17/24 10:59 PM, Xiaobing Li wrote:
> On 2/6/24 10:40 AM, Xiaobing Li wrote:
>> diff --git a/test/sqtimeshow.sh b/test/sqtimeshow.sh
>> new file mode 100644
>> index 0000000..e85fd2f
>> --- /dev/null
>> +++ b/test/sqtimeshow.sh
>> @@ -0,0 +1,61 @@
>> +#!/usr/bin/env bash
>> +
>> +UPLINE=$(tput cuu1)
>> +
>> +function set_header() {
>> +    printf "\033[47;30m%-15s %-15s %-15s %-15s \033[0m\n" PID WorkTime\(us\) TotalTime\(us\) COMMAND
>> +}
>> +
>> +function get_time() {
>> +    pid=$1
>> +    item=$2
>> +    proc_file="/proc/$pid/fdinfo/6"
>> +    if [ ! -e $proc_file ]; then
>> +        return
>> +    fi
>> +    content=$(cat ${proc_file} | grep ${item} | awk -F" " '{print $2}')
>> +    echo ${content%us}
>> +}
>> +
>> +function show_util() {
>> +    index=0
>> +    while true
>> +    do
>> +        data=$(top -H -b -n 1 | grep iou-sqp)
>> +        if [ -z "${data}" ]; then
>> +            echo "no sq thread is running."
>> +            exit
>> +        fi 
>> +        index=0
>> +        num=$(echo $data | tr -cd R |wc -c)
>> +        arr=($data)
>> +        len=$((${#arr[@]} / ${num}))
>> +        i=0
>> +        while [ ${i} -lt ${num} ]
>> +        do
>> +            pid=${arr[${i} * ${len}]}
>> +            name=${arr[${i} * ${len} + len - 1]}
>> +            work_time=$(get_time $pid "SqWorkTime")
>> +            total_time=$(get_time $pid "SqTotalTime")
>> +            printf "%-15s %-15s %-15s %-15s\n" ${pid} ${work_time} ${total_time} ${name}
>> +            ((i++))
>> +        done
>> +        sleep 2
>> +        update=$UPLINE
>> +        for j in $(seq 1 ${num}); do
>> +            update=$update$UPLINE
>> +        done
>> +        if [ ! -z "$(top -H -b -n 1 | grep iou-sqp)" ]; then
>> +            echo "$update"
>> +        fi
>> +    done
>> +}
>> +
>> +function main() {
>> +    # set header
>> +    set_header
>> +    # show util
>> +    show_util
>> +}
>> +
>> +main
>  
> Hi, Jens and Pavel
> This patch is to add a script that displays the statistics of the 
> sqpoll thread to the terminal.

No objections to this one, but it will not get applied until the kernel
side is sorted out.

-- 
Jens Axboe


