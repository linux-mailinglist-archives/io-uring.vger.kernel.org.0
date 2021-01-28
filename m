Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B8D3078BE
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 15:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhA1OxQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 09:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhA1Ouw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 09:50:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFE7C0613D6
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 06:50:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b17so3450593plz.6
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 06:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s8pODfBWHaQpNWcashPUSkcAafUoNUPWcP3DPIUKTjU=;
        b=WEdHchlcmcEhixyRtWmu1QEJe+qYqKJL5RByzSBG3oCvEcrj966ntlz2wQh8YQlE/r
         OPgpkENuAH8x8AUBMgSQDX/nUcFGdSmSRxuHnr/Fut5VkWMdyewnfGM0jFfOeg6CHeJp
         6y+cOI+pft++Xn0+4Zu3CyfIwZcY2y6hLtN5nTUVRuSosulO+q7Nevz/g+sqoYlf14ly
         Eb3yAU75c9GRaxLFT/ZFvPjFXoY0eN0Gt1Hdqvns0skv7NSAw0S5RC0htinWznPqes5e
         LG1E5C8lU8zsJ41wG9XMGobmauGanoucrPZpD3posk3tE8qsBOAkzYaMu6dct29G9tKx
         RLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s8pODfBWHaQpNWcashPUSkcAafUoNUPWcP3DPIUKTjU=;
        b=gIOSeWtaEzCwIlLXEWsAfZcaEFU4TOHeFSl17bv8T4YqKZnwbP/1Dtvt2IKMV+cwje
         VJz77YahSW9tiosUY0orUbJCxvMU+qHWLW3riUB4Ruj0ZuxkV4AUe2KGQiagVnG0jbJx
         A1nxYeJy0kAPUzs0e0vPDhn3xEgEkR3DZO7211J4nrLvWscRIj1ckMi+uicOL4K4MLtX
         JlG5W3kQkItsKXZxgY94gilNV7Jer7T7+AwJFySO3j9N6oL2C7i8OkS9dhEISOM0l0mw
         IgWgp5xRiIn7HharbqBLqNdgESDas9NdkFHsSSAyIeBvZthVAOz5THB47so5td4nf1lo
         Sm9Q==
X-Gm-Message-State: AOAM532lL8G/snLdUG7W4XkdmL+AW+oE4/QM076ZXtTh0Ema549zkGo3
        ge2QsyYmtFnuLNGmtXcm79vXHpOkcfGVAg==
X-Google-Smtp-Source: ABdhPJzeNAvsJAgMGTnjBX0wSqo6KmbHl5OLS498tPt64M7TFXQ9deOeINAgiEEvunnFN89hD5rqJA==
X-Received: by 2002:a17:90a:c7cc:: with SMTP id gf12mr11700787pjb.36.1611845411062;
        Thu, 28 Jan 2021 06:50:11 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i6sm6115206pgc.58.2021.01.28.06.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:50:10 -0800 (PST)
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com>
 <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
 <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com>
 <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d847f4a-65a5-bc62-1d36-52e222e3d142@kernel.dk>
Date:   Thu, 28 Jan 2021 07:50:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/21 5:04 AM, Kanchan Joshi wrote:
> And for some ioctls, driver may still need to use task-work to update
> the user-space pointers (embedded in uring/ioctl cmd) during
> completion.

For this use case, we should ensure that just io_uring handles this
part. It's already got everything setup for it, and I'd rather avoid
having drivers touch any of those parts. Could be done by having an
io_uring helper ala:

io_uring_cmd_complete_in_task(cmd, handler);

which takes care of the nitty gritty details.

-- 
Jens Axboe

