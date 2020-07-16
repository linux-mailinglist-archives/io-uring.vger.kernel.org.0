Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC8222D5A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 23:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgGPVFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 17:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgGPVFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 17:05:40 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC3CC061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:05:40 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so7581761iob.4
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fmrQI2snYhSx6SHO9su73+frsaDE66Z53bxzK+jDG6s=;
        b=rTwbIUAYelJJZ/VpTG9U5cz5hyORaiypDL+KafsM80kXwPQ904/Jzt5eq8o2eYAyWE
         yYRC+nc9c8xbFOjeFxxzH++eJJvslrWdZ3rDBnFVMmuCknXcfA9FmykGDVRxquKb9nEk
         e02hef8MAAL/EZhc1cV1ECBRzShqxe5ZfHK6QExsDKd/z+3dkxJGBKXJSf9Sv1CSJslO
         co7243mEpY9xXc+vC2rzrIG9HR4sOmabsDK1tKSc+l9oIjGDF0Ort+yUZlwtsh/0uCwJ
         5dzc53GAyTh0V6fG8bmZFGsPV+GSA/LUSNT0f/pR+07BCC2y9idgYhXqzDSrHNPKfm/e
         1mSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fmrQI2snYhSx6SHO9su73+frsaDE66Z53bxzK+jDG6s=;
        b=d69IgYT2PpuYMRSzl1kv862Et+v3g1poAmd0eSFF4ixe875dMVd/gEfCLF4YjQJvCV
         glL2m47EAm7XlELq1rCgti30pjkmBOWGup3ni7AZzqYKOaqSgRrCrtdeMxL4EdqhXB+A
         fEepfATvK8szEeJCdNUhHgLbMj4zN9/P73czoMpL/EVDXRdKLUHxZmg3W1WrNEMLV8Ia
         ouFnTrQYrin/Zg2iIs7y5jCfP8qia53tJwytffw1KHKed22T/Bl/Sn49QymD3cqovBiW
         xl1ekFGFGyDWygHl0d8lcCgD12pmBL8iTu7PxPIY0KD9KNtcwhQj7z6wFi5sb+3CdBq6
         jaNg==
X-Gm-Message-State: AOAM532FHgaOn/vq3dT71VFqf2b7sggw7dTbmzSirpsqX90YuyXcUmJo
        mLZcdbbFXd7CqPGCdKZrKCTP17xJXAVNjQ==
X-Google-Smtp-Source: ABdhPJzf8kI3yWBh/fAuvGLjxvXY/UsKSOis8UtiGmtpRJ0QLoaJICY/tnJXpi1B38rTGWaIVcLOUw==
X-Received: by 2002:a6b:1449:: with SMTP id 70mr6342308iou.153.1594933538967;
        Thu, 16 Jul 2020 14:05:38 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t6sm3135183ioi.20.2020.07.16.14.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 14:05:38 -0700 (PDT)
Subject: Re: [PATCH] io_uring: simplify file ref tracking in subm state
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <8ad5d1e7c726ee96f0c55061049188fce0f1c445.1594930010.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d60896f1-834d-a225-ee74-30ccbeda06a0@kernel.dk>
Date:   Thu, 16 Jul 2020 15:05:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8ad5d1e7c726ee96f0c55061049188fce0f1c445.1594930010.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/20 2:28 PM, Pavel Begunkov wrote:
> Currently, file refs in struct io_submit_state are tracked with 2 vars:
> @has_refs -- how many refs were initially taken
> @used_refs -- number of refs used
> 
> Replace it with a single veriable counting how many refs left at the
> current moment.

Applied, thanks.

-- 
Jens Axboe

