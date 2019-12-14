Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF211F38A
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 19:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLNSnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 13:43:42 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42528 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfLNSnm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 13:43:42 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so3279021pfz.9
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2019 10:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QbzwIxwiBFo2cffoX1L047KjXjiOr4rf4SxlZuAhMrY=;
        b=Mxx1kbGm0XFApeOmkSnbAtCAJM74EDCCF8bxEFFLrIiHYpH99UvvEkjQ4pgCeSK8IA
         ZEsHxCPSZEgTrksBJIT61B+gw9G5fs89J4RzYKG0pv3u4t+rEoAgfq/azFGYLkSBa18+
         5Syf7b5XnU0yWLcR0GQmoFbNKZsZ1xd3qfLPSGGCyqoRiHCtnvYlJhtqz7pf/ZRj3Qi3
         gcghiGyr28AfdNoOfIGJxr+WLyD2LcE3FEVMIaRmSXtzNKBCzD+Ff/tM02BL2B3cIKbR
         WqQb7TQnNM4WErVb/MNbQD7F9cgZ+N2g+xH+6Ppt30Pr+ObJM/WR+w19vM8dDb4WQPox
         UK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QbzwIxwiBFo2cffoX1L047KjXjiOr4rf4SxlZuAhMrY=;
        b=Zk92Ne6L5/eUT+R1Dk0zsW+w/z6RQSeE9Pia89ScLnUc3+FZZ5d99YDBWcSirFcjde
         YfFa7mqMwLa7yrOGCKmAilFT1680ku8CkFxk1eLRY5j9MQM1n/6A2NKmKpqkou/54HwX
         4IDcF16ywDZ9vOKtncPPXkvy5tN9JZVlQUa3td6elnfGrKJllVG3LWV1aCDTBRFmSAkz
         M9JHMp/VDRlBg4TbXxS+3wAg+jEwKYLxLyMRy+ATWUj64TcHeDAw578nTtMH6mAJirVI
         w4uwdmct7oYnUD5UPrt5255d58mFja0sxTyn1L1+RmMZFmiUY2zMYOqbHQo/SAegdQsC
         emeA==
X-Gm-Message-State: APjAAAWTkEALw52vks0XpHL2FnnCzMd8sCMahEDEeXOh5C4UF29roAGU
        K+wTfHzegvT+SV8K/a2Vv/ZdDRbmjTU8Wg==
X-Google-Smtp-Source: APXvYqzRVHXJbkaHToZpXQuBbgfNfNrwyA7GnRMI4cTusCicSSlssbKOJWnBtTcZWc4BIUpjcxob9A==
X-Received: by 2002:a63:5d03:: with SMTP id r3mr6986201pgb.306.1576349021449;
        Sat, 14 Dec 2019 10:43:41 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m15sm15216850pgi.91.2019.12.14.10.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 10:43:39 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
Date:   Sat, 14 Dec 2019 11:43:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/19 7:53 AM, Pavel Begunkov wrote:
> There is no reliable way to submit and wait in a single syscall, as
> io_submit_sqes() may under-consume sqes (in case of an early error).
> Then it will wait for not-yet-submitted requests, deadlocking the user
> in most cases.
> 
> In such cases adjust min_complete, so it won't wait for more than
> what have been submitted in the current call to io_uring_enter(). It
> may be less than totally in-flight including previous submissions,
> but this shouldn't do harm and up to a user.

Thanks, applied.

-- 
Jens Axboe

