Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAC6179107
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgCDNOH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:14:07 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44540 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgCDNOH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:14:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id n7so2314522wrt.11
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 05:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v1tToJIZHbp6oHGAoeYQQFZ+RpQrRi22ML8rDx8DbFs=;
        b=VCGd1mijBcxqlxy8ZuNLTu5CSeG6OPcmV0L4Gx86OEgy0VQXWVlSPlHHnC5toiJRh4
         Opg2RYoqeHv8id2wN/wRqf4ZAeKGGFge0iZY+GFQv5WFaa6wnEqN/wOUF7DpAonDN0xn
         Ema6J/jeqO8Em7U1nf9ytTK2uYvzPsBm8R7V/IMOJQYW7ukE60gfERQN1+4qFsEeMQ+F
         k9lvehqMMmv2SiFNp2is7tBr3G0Gq4uAAGxfdFjEw755IaR8kyGTVP7FhDAHJSqMMazB
         f9+0FWWoU8R6+LhgC32zqjjG62EjAzR5cCf5TCRjBWSByuFAO8rspkDxNRuSREOIrKHj
         lLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=v1tToJIZHbp6oHGAoeYQQFZ+RpQrRi22ML8rDx8DbFs=;
        b=Y1nyBhG1rxt2pnIrumUd51eHyBLgg/HwH69Vjv1LMl3/NCU6HveF0h9ow/X5yxepgN
         +Cmci6B5NM4HYryYr+GXxdSZJ3IF4i63ruSI7SUqraGt3ARMP82EyoMA5smG6qtEovq8
         op0RFspPICVvZor8gpTxNeNUfXwRRhbsBr0/s/vMRWhjtOy/qGcye4WHIDjCEZUbUBoB
         CHTOP/uyss+t8phLtBrXDxVffsWI3tpmPGt1jnAO+MPN4tuDQTOhB70QNZ7soxYnka4Y
         +lVs3vk6yKkrYcNLvzG0hgX6Tv5DIHPxlBt6xnhDEpzBJ87guvNPGUoSH7n3ZPS3q4U4
         fHEQ==
X-Gm-Message-State: ANhLgQ3qczzkIpldq3KsFYZxkPa/eL5HsEf2GaxFVNv9n6b+W/5ledW7
        PhayrjRLnco7JYP+AC1JDkE=
X-Google-Smtp-Source: ADFU+vvQreEf9U3wyYrj7GGm1Z1bNm22MMvezwLQoU5w8rplSVS2j+stp0+u38PyD4AxCzhOmicDmw==
X-Received: by 2002:a5d:4b01:: with SMTP id v1mr3977420wrq.422.1583327644419;
        Wed, 04 Mar 2020 05:14:04 -0800 (PST)
Received: from [192.168.43.187] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id t9sm3839546wmi.45.2020.03.04.05.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 05:14:03 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: test patch for fd passing
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     jlayton@kernel.org
References: <20200303235053.16309-1-axboe@kernel.dk>
 <20200303235053.16309-5-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b2568465-1f35-fbb7-96df-f1aa4801c969@gmail.com>
Date:   Wed, 4 Mar 2020 16:13:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200303235053.16309-5-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/03/2020 02:50, Jens Axboe wrote:
> This allows a chain link to set ->fd to IOSQE_FD_LAST_OPEN, which will
> then be turned into the results from the last open (or accept) request
> in the chain. If no open has been done, this isn't valid and the request
> will be errored with -EBADF.
> 
> With this, we can define chains of open+read+close, where the read and
> close part can work on the fd instantiated by the open request.
> 
> Totally a work in progress, POC so far.

I'm concerned of having and supporting all these IOSQE flavours. Isn't it the
thing that can be potentially done with eBPF?

-- 
Pavel Begunkov
