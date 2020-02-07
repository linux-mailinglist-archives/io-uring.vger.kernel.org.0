Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D075B155BB2
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 17:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgBGQZW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 11:25:22 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38787 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgBGQZU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 11:25:20 -0500
Received: by mail-il1-f193.google.com with SMTP id f5so24133ilq.5
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 08:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=D0i0v0Cz1w3Ih0IH4JNeGVFe/a2Q5iggZsx6TJ9mToY=;
        b=1puzGfr9auD7dz8vqFdog9zyFWiG/w03wmti5jFrzbn5deIO9B+5RtKhvJ1BtVSkA4
         Omm2qTErgNB3NrxizQzDNCjrt+qbxOGAAdoSZXbDjSZ0QgIUtfKM+oWmuCQsyWoE/+2T
         MiX+Ye2enSXvnDLbXnGcl3OzH+sKm1umdiPOaoEyz5rxMkn3DxR/NILq13X+ALJ/88G3
         oEPs7bqq4J11DUU+DUsixPNUbT/ZYliCth/N5lFjz96JKQc4kM0Booo5UJQmsqiZUOKS
         Bh0Hn88jw4i/no1aT1OHq4WOvUkepjioJO04mqn11jRRsZIBZDxpQ5CdWcGrxwBBhG12
         oErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D0i0v0Cz1w3Ih0IH4JNeGVFe/a2Q5iggZsx6TJ9mToY=;
        b=EQymroEiE2ZA7TqJsPOTozaZ6PtsdJUsFz3Fxb65uz+LrJ1aPbB2MNlC47QLZDCnwb
         KcTuYYGxw64KFR7UGrlsHvE2B/XvtZ2Hw6jsK5TxshcFZol00INeVtIeaVT3ODjvr+uf
         1qPDFnG/TldIoYs0j0wfNBVFVi7s5T8Pk34wLKxZrqUOIzgrGmacQrLHPfUaOHT4ewCI
         TXNcnrYlFQ2esUx/DOBEBt0Ht6p4/M/P6G/igOc1SlJjuXASOdLg3C6t/UZrCLIIbkr1
         MhOgIhC1Iv3szMUnfX/jnkppX0EiVAmnMQcR9pCYw6SFoxp4WbgBgS98DvGSaIVnpYLd
         kD2Q==
X-Gm-Message-State: APjAAAVzkRtYmgTTtHoW07q5hDutF4TuErbHBZ3L3x2IIrakaARYTuqr
        /8/jAHTZHrpfryYZJ7OJPspiyQ==
X-Google-Smtp-Source: APXvYqzS0iPhHfnmffotPOpJOKrniWWF85K0/m3gxuzflJHnAwqdqS8isV5VH0mIWJEG12YTs6O+Kg==
X-Received: by 2002:a92:8311:: with SMTP id f17mr202900ild.82.1581092718939;
        Fri, 07 Feb 2020 08:25:18 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z15sm1433711ill.20.2020.02.07.08.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 08:25:18 -0800 (PST)
Subject: Re: [PATCH] io_uring: remove unused struct io_async_open
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <a14a8fc0c22be0dbbd9767f424e876704d9e9c8d.1581092449.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f4bbc97-0cb9-1f45-db7e-0bf28b64f01a@kernel.dk>
Date:   Fri, 7 Feb 2020 09:25:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a14a8fc0c22be0dbbd9767f424e876704d9e9c8d.1581092449.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 9:21 AM, Pavel Begunkov wrote:
> struct io_async_open is unused, remove it.

Oops - thanks, applied.

-- 
Jens Axboe

