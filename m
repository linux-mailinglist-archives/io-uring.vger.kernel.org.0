Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BB743933D
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 11:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhJYKBm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 06:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhJYKBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 06:01:42 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC55AC061745;
        Mon, 25 Oct 2021 02:59:19 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z14so10650513wrg.6;
        Mon, 25 Oct 2021 02:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=gHtd2usMmK1BtETpykfNFHKma/8gTHTOEFGm/6yCpKs=;
        b=YiAeRaix7x8jo22t1Kd6yDDe2MIW74042HKhONKl0rhFgerCICKXiC25qY4hISXDb0
         pmZKyoPUWkhgAABDPFeuWRrpU8iejnqS+nf7a0tMXXQihLHWJ2lZoPMBif2druL3s2ps
         OYP3BMdpHpn9njSAejImM9SfX3IJwYQmm/a530nl4RwQbpIF5LuEQNsviAoDo48ww04G
         e7a/rNVyUdyt/pvEqqVnDSFdNGs4oQYr1ZMPG6NzTWwuszZKHPq6r/USDsFH69WHMX20
         JUoAq4tDYStk8lRn5zP/VC1AB2u6f4xIEY//aEomFdmeE7PYqqPplIP7ScJrvogP8aOe
         X3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=gHtd2usMmK1BtETpykfNFHKma/8gTHTOEFGm/6yCpKs=;
        b=PhsHBAZP5gA2npsdsU7VPwMyEihANKSjADl1tkRp/A+HV/LKJWUEWRFVps+g4F4HhU
         rs9a0dOeUiXuKZ8JYA5IRisZJkg5bzYS3tZVfXC8QDZMBjlGmegEdyAXNb1kM96l02wK
         mPy2d7qoN4pAvXMq58cL4qGBLvTD5C+4nulWXpWcLvDQ/rGorSPMsxI11VcA9VE4oomb
         T7qBlhFdeHgMhX0eQ3GaGyFE8ke+vtvq9gC6qoAwrJUgDScQwaznN/dOfykyqhNCXFiz
         Fin+VLl74rsHR/CbvWUxTb9UggtIJEkXzUL1qjECFYjKrnFuyz2eaJldyHrNT9sshhWY
         DOPA==
X-Gm-Message-State: AOAM5322h303LC3ZBxUmrq/3sDg04nWkvoOfrguy5J5MvbXIbIOeVu1K
        ovW4DHu0MU6JRMV3Y3+A8yrRRZpvxTk=
X-Google-Smtp-Source: ABdhPJxxtO4zOATCWbIb7PkPrsG1rCgPQ4WsjLjHeQlDj6d/TePXairv5gmt4aBX6zPLs13G8pI+4Q==
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr22487679wrh.272.1635155958509;
        Mon, 25 Oct 2021 02:59:18 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.144.165])
        by smtp.gmail.com with ESMTPSA id m8sm15646802wri.33.2021.10.25.02.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 02:59:18 -0700 (PDT)
Message-ID: <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
Date:   Mon, 25 Oct 2021 10:57:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: uring regression - lost write request
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Daniel Black <daniel@mariadb.org>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
In-Reply-To: <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/21 10:10, Pavel Begunkov wrote:
> On 10/22/21 04:12, Daniel Black wrote:
>> Sometime after 5.11 and is fixed in 5.15-rcX (rc6 extensively tested
>> over last few days) is a kernel regression we are tracing in
>> https://jira.mariadb.org/browse/MDEV-26674 and
>> https://jira.mariadb.org/browse/MDEV-26555
>> 5.10 and early across many distros and hardware appear not to have a problem.
>>
>> I'd appreciate some help identifying a 5.14 linux stable patch
>> suitable as I observe the fault in mainline 5.14.14 (built
> 
> Cc: io-uring@vger.kernel.org
> 
> Let me try to remember anything relevant from 5.15,
> Thanks for letting know

Daniel, following the links I found this:

"From: Daniel Black <daniel@mariadb.org>
...
The good news is I've validated that the linux mainline 5.14.14 build
from https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.14.14/ has
actually fixed this problem."

To be clear, is the mainline 5.14 kernel affected with the issue?
Or does the problem exists only in debian/etc. kernel trees?

-- 
Pavel Begunkov
