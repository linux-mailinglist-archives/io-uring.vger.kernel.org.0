Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0376914A81A
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 17:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgA0Qcp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 11:32:45 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42089 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0Qcp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 11:32:45 -0500
Received: by mail-io1-f66.google.com with SMTP id n11so10676091iom.9
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 08:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yov7ap4biFBzdzvuUJNulONNcHIgznC4VCf+Gem9vsM=;
        b=DDTA9J1CCeDgzLa078hSsNZrE5s+EWQhKdJ2pqw/kyeJPhUdV2fImtaKqWoH0yU2qT
         u+V3r4O9ouTvDVKCkNBs6KL1ZhLd+TSZ2YoubgVTvhqVadU0FvkTkbibF+iXAGhzk+b4
         Gvje+NpQRSk2WLu1xUSn11H2Brc+4tKnly6s7uluSICp9V5HKUQWB+sBmQbvgJbH6yye
         i8bWFFK1bCwjh7UHjnSzHZ0rJ+dA0gF44r+dAL1oF70gJnEw4U4ctfwJTS9ZZC+7thVd
         uFbYCeaccmaIiop1Hmg3wYzQ6J4qgfZwYOL4lcOOPD2ioNKD6JHg+Owwk48k3DS2zfPl
         vCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yov7ap4biFBzdzvuUJNulONNcHIgznC4VCf+Gem9vsM=;
        b=pIzKokE12hRhvksxOfoJpq/sZKjTNp8Ayi7GtjWPeEB0yOLZULEq/ALknaVP1Wgvff
         7GqU39uvb78mpDpyoNrvUybRDhubDlGK7iNwK8zFvE4rvAghxq/AvQEQ6kQDQhc6w/nY
         3ThJoNrB0TsZH+CdVcdEWFOlmu7v8amOC1u/XXBNLgr42fFNYOkXvG7xorhX0rjYUVM/
         CXP5wPUXsH6OuEWcYAfSXIKQg6xzsj3trE794vnI/qgSXlOZCNBGrnZLtRfMQYVoLEv6
         OnRo44a83Npynzk3wHSiZUq47ZSZgR+0nsbLtHn0A6Rg7/CibKLAtwn5I2OGluURIld4
         HOsg==
X-Gm-Message-State: APjAAAVNFPWZfBqLHlj158UO/TC79OmLtH0AaClUOP4iX0iFkBreohLU
        UlZiTmBfqN4jwqLg3SO/+c7h5w==
X-Google-Smtp-Source: APXvYqyMgBh8BeGwDTsAgvsRxyN69Aa0BceylNk8A0OQ2Na89SDXKSpTd/BI6G96G7GcyQnHsYUnjg==
X-Received: by 2002:a02:c942:: with SMTP id u2mr14262871jao.49.1580142764895;
        Mon, 27 Jan 2020 08:32:44 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n207sm2720985iod.55.2020.01.27.08.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 08:32:44 -0800 (PST)
Subject: Re: [PATCH liburing 1/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <20200127161701.153625-2-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1b26e79-507a-b339-2850-d2686661e669@kernel.dk>
Date:   Mon, 27 Jan 2020 09:32:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127161701.153625-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 9:17 AM, Stefano Garzarella wrote:
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

You're not reaping CQ events, and hence you overflow the ring. Once
overflown, an attempt to submit new IO will returns in a -16/-EBUSY
return value. This is io_uring telling you that it won't submit more
IO until you've emptied the completion ring so io_uring can flush
the overflown entries to the ring.

-- 
Jens Axboe

