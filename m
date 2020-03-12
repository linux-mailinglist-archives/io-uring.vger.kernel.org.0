Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014951830BB
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2020 13:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgCLM6W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Mar 2020 08:58:22 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:34017 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgCLM6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Mar 2020 08:58:22 -0400
Received: by mail-il1-f193.google.com with SMTP id c8so5393867ilm.1
        for <io-uring@vger.kernel.org>; Thu, 12 Mar 2020 05:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Sn8Ieo7NVEgRSwI66zcc5ZxxDwF8xi+mba+pUiqujis=;
        b=zpGgNgpX3Gz1Crt1QnWtgSHiAnRp954kVzEDNvrMBlo498eFmOkRfhqtEw+C5f4tSd
         b25vII8fzMfWeLvTZqNUODtJ4B+x8E/xhw2ARtcczBKyk50AIC5zMm694reQFaFwWGYw
         LnSK2JRJm/rvsLiR4kbIQSCWa1QGe0lhEKRIDZ6OJBz9q4wJi07/5XWUSwpZV0IOD3P1
         KjuZNDTHHeUMhLRvYGCLgR3F6dyznNAhhHsrVIFxkoJAHlTkDT/z5oy9iA1xLJOuyTI0
         fC83BeV16xNON3wR8QEk0UFd4fE0d3ph+Ws2DaTIcEbLvCwfiPjy7QM79yec5v/FTA9E
         0BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sn8Ieo7NVEgRSwI66zcc5ZxxDwF8xi+mba+pUiqujis=;
        b=tIe+tIcIHe3RNP8NN4OOP/BQa3miur/DPzjvX02pIlKFrUqCEq+/jZilYK0F6a5H8f
         C3wTwMJAMH3l391ZqdzmNhpLmmfvnISsYf30Xn1NXnwVbgVxJVHsA96SlIdyGNKXgOdQ
         WpZ6elZ7bzoNMVBazJ+hYLcj2b1mKJNIYu2F4oRlZV1oIj7xzuKha/ePRzCc8A6yIiog
         6Ow9SpLbSI0Whn3+VWWDdVRAHQ21+GfruGF2Vz/2uRGTXl1fSjP4qcyqye5zBKK4of1r
         EvHQrRnxlW2B6Y0GwrgPDc21JJT7EXCju98mQamNqnBieD0Xu6UsLRV+fO3AmcTsYmA0
         4KWg==
X-Gm-Message-State: ANhLgQ18ucG406K9GdMAHxNf+8VhAg6JIKZq7pQghmJTd/40tyztSVrM
        okyqTLwojWgvuiSZgiBpCMVFjSyC2+oGWw==
X-Google-Smtp-Source: ADFU+vsPwwoTqMMLqnBq6G5bPcbEuiI43ylNmnr6aELplWK1KoQpIWzGNvgHXJS2kCbCTGt33BcaGw==
X-Received: by 2002:a92:49db:: with SMTP id k88mr8205459ilg.293.1584017901136;
        Thu, 12 Mar 2020 05:58:21 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y1sm932050ioq.47.2020.03.12.05.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 05:58:20 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix truncated async read/readv and write/writev
 retry
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <62d7aa88-8765-d0a1-0db7-6b20cbf9a3a9@kernel.dk>
 <9ecffed7-0ee1-2d13-9662-a145d081d553@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e1822d7-b3dd-9ef1-192f-73d6f709b11e@kernel.dk>
Date:   Thu, 12 Mar 2020 06:58:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9ecffed7-0ee1-2d13-9662-a145d081d553@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/20 3:36 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> I haven't looked at the change in detail, but I'm wondering if this
> would be needed in stable too?

It's just for the buffer select stuff, so won't impact 5.6 or
earlier.

-- 
Jens Axboe

