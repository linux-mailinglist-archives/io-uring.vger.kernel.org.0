Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EBF3B0B6C
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 19:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFVRae (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 13:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFVRae (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 13:30:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F214AC061574;
        Tue, 22 Jun 2021 10:28:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id my49so35630788ejc.7;
        Tue, 22 Jun 2021 10:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rxHuBa1i0T0msjcVyEp1MtQ0oShogefGvOr3nfmR9rs=;
        b=OWrKO3zyz5Jk4k0JFzkA2VaasAftirebpqFfv7G5cqvaQyQ8hms17Wra3CWpa+NBpy
         oUi4dwjV3toAadmOx1RcuRtaN+7QaR17qkIiK8ZElCsNjcumjCjn2YBR80DUr4v3HR2H
         V2nsKUJV/euQpohCRI+INvXcvHhv4RE33UXSzzCXaxzwNo3PIm9UaPcr4/3jnALFaBlg
         ny09lhAtuLkgQ4cIa5WZgiyqbGk4LPzSWxa52Fy+hDiW/O02C1tGS081winxu1YKkn7v
         j3cUW7Vbb/useBxA4bwXWDqUxAZxN6GD+ESVgNuZm4FMKKiQ0t1OO0XrgcG6p8f6QJl8
         Jb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rxHuBa1i0T0msjcVyEp1MtQ0oShogefGvOr3nfmR9rs=;
        b=HA/ATyIWSp4ZKmxCYv+763byyT8QU71B2gZTOcNDFZ+RmjncnNN4gAitaTVUBgOspL
         zz58vEfMhWMhtGzTysOae5SACpdvRknIBHfBdm2+4gWohvKs7/qTCWeCISVVGwsM6YW7
         EaqXbBhQ/OEoaRQARO1EcIQzRXsK71JQVEnnQ8QsUUWABqf9PoRbiSUJZOAkE9/jWC8H
         jWVjbsebpclEim4DvQ+FFoNz/2UprNgARvDGY4w1L9Wo8q8g4qf0w3mhu+3dRtfqq+BX
         4OrBOV8vNmqtX2lNHRvH4HmGGlEFByophskOx3H2OMVtkLfoEBQglFwY8uROwPnf3XwU
         yZrw==
X-Gm-Message-State: AOAM531cwh9C54QOPcdKKDgoVVwzMQ20KN/fQ+UTfwvvJvK95UaEl52U
        TEKu20kt+Fsxjoy4zHIlZtSCJzOCyYv4iJPK
X-Google-Smtp-Source: ABdhPJzAvYIdF7Y+F3jZnp5Jej05aqfiwSyRvD8xIawE75/d9zkN0iEzQ7N+u3FDHbyGaqp/lAg8DA==
X-Received: by 2002:a17:906:1291:: with SMTP id k17mr5077901ejb.349.1624382895449;
        Tue, 22 Jun 2021 10:28:15 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:9d6e])
        by smtp.gmail.com with ESMTPSA id m26sm6285424ejl.26.2021.06.22.10.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:28:15 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Jens Axboe <axboe@kernel.dk>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
Date:   Tue, 22 Jun 2021 18:28:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 6:26 PM, Jens Axboe wrote:
> On 6/22/21 5:56 AM, Pavel Begunkov wrote:
>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>> This started out as an attempt to add mkdirat support to io_uring which
>>> is heavily based on renameat() / unlinkat() support.
>>>
>>> During the review process more operations were added (linkat, symlinkat,
>>> mknodat) mainly to keep things uniform internally (in namei.c), and
>>> with things changed in namei.c adding support for these operations to
>>> io_uring is trivial, so that was done too. See
>>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>
>> io_uring part looks good in general, just small comments. However, I
>> believe we should respin it, because there should be build problems
>> in the middle.
> 
> I can drop it, if Dmitry wants to respin. I do think that we could
> easily drop mknodat and not really lose anything there, better to
> reserve the op for something a bit more useful.

I can try it and send a fold in, if you want.
Other changes may be on top

-- 
Pavel Begunkov
