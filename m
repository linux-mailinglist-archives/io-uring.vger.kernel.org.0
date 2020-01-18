Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735181419AD
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 21:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgARUqj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 15:46:39 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45008 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgARUqj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 15:46:39 -0500
Received: by mail-pl1-f193.google.com with SMTP id az3so11360109plb.11
        for <io-uring@vger.kernel.org>; Sat, 18 Jan 2020 12:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aBvwG5hs/viXjFOybOIYOqL0J9/NjAJR55aMcHkMqz4=;
        b=Inb6NhQE6dYl3CVHDsOi2zXEBpNBU5RUcTsbaziD/JicVz7jAIJPYErWhulW0IFZp3
         cHAFAsTbSpWgpbFJmrSjM42Td8TOgCcYdYy14I3nGBDv1Qif2VoKS/CB+acWtavKJ7SA
         yL+4Zfo3ukT6yP30COGuuI27F4hb7jGd5IAngkeHzL2N+n5XFOsCnTwe0wpZGtlBFM2E
         Phwb0Q1CACMW+jKyz+hU1TlshN1a0cPwtEWQ8Jg1LpHoztXMOfGoktO0Eqj3YJu1U8Wv
         7ObOXnYx0Q/fkRYmp7zdzu5D138+Tm0KDmQUxW55+WlEc2qeUHRMeeycc5FWTatrrW+g
         xKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBvwG5hs/viXjFOybOIYOqL0J9/NjAJR55aMcHkMqz4=;
        b=nOuvoqzP0U0hyQFYrrMOcUFN52XKvg5vQZkCoM9Ro41ZTftsZgr1I6VE+Vw/WW78OR
         9l87nPmhm0hE5s1HuiIHvdNQSu/Wr9NoDml1t/nvfpl3PnHtTg/L06G52/rmXpviC/bE
         KFjSzpngdJZcaahkCG3TdEgpkw3eUwwYJ5PtTCJVbyFY2/pq9lzDTMfOgjzTMpYzAvni
         IpfOKZLAh/zirmwLcPcNxY4wKWtWcm+APRLBgFqOPgjoXH7c76GxeRhevbQzADizc+tj
         kGVIIGrFYjaWZQjoyuAEzDLFYramIMskSWFhgHp4E4V1+UosceA4qAlqpyxU+A5z6BMt
         i+MA==
X-Gm-Message-State: APjAAAX5XAz1OPaLs80U06E8DiIeMHN6rJRgaucEGZLSkUT9Q2fakFIh
        oHwLb2Uprb/ORxDAPZyzmb9PTxDfLJY=
X-Google-Smtp-Source: APXvYqwWTGIwEbfvkeQFgWzlMG5o9J+qp/K4p7RgFLPHkAwxfZU7UIbBuw6opSlpBy0gmhhLpiTp6w==
X-Received: by 2002:a17:90a:2351:: with SMTP id f75mr14131461pje.133.1579380399007;
        Sat, 18 Jan 2020 12:46:39 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o7sm35806945pfg.138.2020.01.18.12.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:46:38 -0800 (PST)
Subject: Re: [PATCH] io_uring: use labeled array init in io_op_defs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b23c570236ab4b1f47603e52ef545875ac632df8.1579372106.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8eadfa1b-5dee-a6b4-e217-81fdd2484218@kernel.dk>
Date:   Sat, 18 Jan 2020 13:46:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b23c570236ab4b1f47603e52ef545875ac632df8.1579372106.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/20 11:35 AM, Pavel Begunkov wrote:
> Don't rely on implicit ordering of IORING_OP_ and explicitly place them
> at a right place in io_op_defs. Now former comments are now a part of
> the code and won't ever outdate.

Looks good to me, thanks. Applied.

-- 
Jens Axboe

