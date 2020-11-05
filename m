Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39C2A8A4F
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 00:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732086AbgKEXAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 18:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732035AbgKEXAQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 18:00:16 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF6FC0613D2
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 15:00:16 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id i7so2408670pgh.6
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 15:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OvYwvCtv9BsTsgOgCSxtjHee/rF85IGvofo8QEcFjm4=;
        b=PZ+gwXHO+XguB/Pa3byQQbvix0/UkZaGG25ITlMDyeaM2gPjbhVVRNPq9zO4CHFbHH
         jZwCP25LqmJvT+xYCUaQZ26GnlvSk06fE4Q0uM7CO5g18nZ7Gwd+VhuZnLI34K9wVQ/0
         AWDtMFZvBFv93X6/NCDqmLumboSYUXhf0HwT+jsr6RZqD6/xFdhTCcPuJilfG1ysDgo2
         GTbimA7BBcAYiUAOImEqp+x3Yq9K5aw4XBwVl2GSwavaMh3PTzRK6pqn1iw3mhT08EdV
         usqgef5D6f4fG3ArMoKoBy/kJUpMN1ZdTr+8vYGjrgGHrvRYLdRxoUf+fFfHRXvEm+Ku
         qYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OvYwvCtv9BsTsgOgCSxtjHee/rF85IGvofo8QEcFjm4=;
        b=am5BXaFuvK7ImxstIJ88H60B2A+9e2ZpqW1p7kOCQ46tOwmJnbTP6eViCMdu1iLml5
         aklFsoEwvRpr6Lrtd+5dJ5qi4xUCv3nem7t/wr9S9FzWs8p9Ig/601DOFY+CZdKJqJrs
         ogQ/KZB5hAlolH/gcTQj9OJFMv2UQOEmrJ7ChRzW5ohvR/PUzBV7EpX8m0PdVGXN1fig
         yZz2ZQFaXD6ZzNyMcMBA0DzkgAkkDac7/CapAlzAQJpgMd6Lw+DEkQEciwxoojhsLvka
         BTNuWreG2+k/9HiIPAIkM9JVekW3eoV2z7aArGDSNp7xi+BAtr28czYVZ9OCetg8aOo9
         vAPw==
X-Gm-Message-State: AOAM532YSaHPMWDx+ZHhh4RFSfvo2OpLSP/+kJ74RL8hkxvUgCFxUzTx
        1/shQXacbMe1SuXywY9S1ES7xg==
X-Google-Smtp-Source: ABdhPJxA99PTbbGhEVdvn/QLjqmdmoxqWwXPQnVobtB7wzIJSfgV8QXmHXQGClUvZPZqRWIe+EklyQ==
X-Received: by 2002:a62:36c3:0:b029:18a:6031:ac50 with SMTP id d186-20020a6236c30000b029018a6031ac50mr4576872pfa.61.1604617215846;
        Thu, 05 Nov 2020 15:00:15 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e128sm3601369pfe.154.2020.11.05.15.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 15:00:15 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix link lookup racing with link timeout
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <c51ca0ebb562612484b248038142184572ecf2dc.1604614925.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ef7861d3-9eae-0be1-1ade-146343d3a780@kernel.dk>
Date:   Thu, 5 Nov 2020 16:00:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c51ca0ebb562612484b248038142184572ecf2dc.1604614925.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 3:31 PM, Pavel Begunkov wrote:
> We can't just go over linked requests because it may race with linked
> timeouts. Take ctx->completion_lock in that case.

Nice catch - applied, thanks.

-- 
Jens Axboe

