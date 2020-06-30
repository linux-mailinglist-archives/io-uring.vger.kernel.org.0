Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194BF20F6B0
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388519AbgF3OEb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgF3OEa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:04:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA739C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:04:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 35so8530873ple.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ds8NJELzpunkrEHDd769F4D90mxJxPDuZ8OxZASP/Q8=;
        b=qIjFmW71lqz7dcTRnARz25oRYUm5VK40VHb60bg9Gn0Y8m+Yx8ORm4McXmdcT0XMNp
         IaLWnHMgFD2FHl56ahfDejF+cxt/+d+P7JXKEYhJnHd9aHTC9yqxzh6d77HSHX893o5H
         rbgCqYnhJt/NPVyaynuxWvBBqK3t7XL3P6Cn2iB/0Pe1Udela2k5LGcU6jdvEtn4vU48
         pRPj9/UXFAKKIbb3jQaIwIHsi7bo83KUOohfNzECF7i0hBP2vL8x8kvCjjWoTbaQXwQA
         mCRRErJAT4rdkKcgiM1l2KJ8/Ds/X+3c+wgBtGfhnhGnqUWk9wpmsrCgBkjHQxmGMaK6
         87ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ds8NJELzpunkrEHDd769F4D90mxJxPDuZ8OxZASP/Q8=;
        b=rbWvhe+aYjVHbN4leHqLqXo0CZA2zOq/svKp5pD/qdpax61ioroC9gj+FkC5QdY+PZ
         +ZOo0N0zc35vZpv98d3ppJnHWgbnTBR68Vitt0qysNvJvR1znY34pBcwco9PFqyLj8TG
         WA6GtzFL2E36E9bJ4CnGaFLv32WPwbKH8KND5ctJ5CgKWttWIlK2J3nkq/Zjk5gssIWb
         hhDobE2BOvuPhNf51md+3RkUcfMBLoSHvsOL2YXqSI/V1H3KYp2TIcd8c+SQmUMjRAFe
         1zcH8ZJ3NkFkcI68BfGMPeUpNawxzCbKFs2F6rVvcZpmt7Bdkguv4MaraDZ1Wjd27K6E
         cIxg==
X-Gm-Message-State: AOAM530NNrw4uSW1CzXRkFiJkYUS1ecIPm1LzEShuGwlTQmjYgG7q8Kj
        7z8CkdHuicYbC3UW8V193SfQYYxHB3fTgg==
X-Google-Smtp-Source: ABdhPJy8TrSXC0GYNgLB7HShWRxYMWEgl6NMuVQXxbQyy3Q2vC0WjuRiFNlUbbFzFTSGBniLoQgPvA==
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr9922085plq.192.1593525869097;
        Tue, 30 Jun 2020 07:04:29 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id y12sm2853867pfm.158.2020.06.30.07.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:04:28 -0700 (PDT)
Subject: Re: [PATCH 2/8] io_uring: fix commit_cqring() locking in iopoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
 <75e5bc4f60d751239afa5d7bf2ec9b49308651ac.1593519186.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <65675178-365d-c859-426b-c0811a2647a3@kernel.dk>
Date:   Tue, 30 Jun 2020 08:04:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <75e5bc4f60d751239afa5d7bf2ec9b49308651ac.1593519186.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/20 6:20 AM, Pavel Begunkov wrote:
> Don't call io_commit_cqring() without holding the completion spinlock
> in io_iopoll_complete(), it can race, e.g. with async request failing.

Can you be more specific?

-- 
Jens Axboe

