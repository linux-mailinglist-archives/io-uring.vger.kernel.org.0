Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA56014F4A7
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgAaWWc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:22:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38989 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgAaWWc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:22:32 -0500
Received: by mail-pf1-f196.google.com with SMTP id 84so4075995pfy.6
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 14:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ym4CATryr3QJbBXCpmH+mWSLbQwwdB6r4IiJNjhJKxM=;
        b=AbeaxiAXSmyiyWHNUbJzYqLQg8oCe/1I9MYoknkNjSSPvw9PWYJllaHHOTXONw12vW
         N7IVuUFhIeoFuznn5PPdckAaTra7JYdCZdxcDpe12Ek/R4Pn7uyMW6bdd2pZ+A7N0lk6
         xfJWkSkh8RSWWOO9Cbdn8cRbOBsWA5bUs8wzjfKvrhOWvDsZnskFKOGLGA731rNjTiiT
         nK5Eyc9z4+Sw0N2W2l1JaNdyXM1uhKMKp0jwX7qgsi7FONnqpsddAwyEyNEJh7/BPI6a
         S88kJycsXPYxc/2R5u+zip6zxGOncmgqexxtkknyJA4KsXGpDfbkrp4f+TVwovCXrjhr
         OF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ym4CATryr3QJbBXCpmH+mWSLbQwwdB6r4IiJNjhJKxM=;
        b=WyB3nDYy3qqcOQCDYi3UgoUtCH8StS6aEaIgcCnz4Wv9XsInuq/OpfLt26kz3UeNOJ
         Ugwj/Od3Gs7HYYRdz9zjVNwgAZvFZfzy4+n8ljDSBlAroGw5Zmp5rzQ7gNEdpOj9KRKs
         MYr6AENjnwMO2Ows2kU0F6PIGcO7nGjkxlnEHyLKazTKvEAN5GEc2f/dlhEos2NWV6d/
         G+C0eTXpdHvPqVYYNfEhJcl8lKv8S6iR4Zy0Rrvx5TaCTlGh6pC0LU5JaBn63uzMHn39
         2msbMlrSB3DqjeO7Ctx1IY0wFcSs6rwg9Xrs+pduOdbJdtRwJzSnVq53zcJpzMAx5mws
         u85A==
X-Gm-Message-State: APjAAAXB1fnjLbN6zB/DAkzvsgkfmfI79iwGeplnDS8OfsGpUKF5PYMj
        UnBr1ajL4TUebaCn3UtJ9rcIVQ==
X-Google-Smtp-Source: APXvYqxTillDlW/mS8lPlT9SG5wZBL0oehI9eN5JpPJ1IpJJMPh4VPircIzIYcxv85ZTCYsJ2zICWQ==
X-Received: by 2002:aa7:9205:: with SMTP id 5mr12785889pfo.213.1580509350445;
        Fri, 31 Jan 2020 14:22:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id l10sm11260963pjy.5.2020.01.31.14.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 14:22:29 -0800 (PST)
Subject: Re: [PATCH v3 0/6] add persistent submission state
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580508735.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
Date:   Fri, 31 Jan 2020 15:22:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 3:15 PM, Pavel Begunkov wrote:
> Apart from unrelated first patch, this persues two goals:
> 
> 1. start preparing io_uring to move resources handling into
> opcode specific functions
> 
> 2. make the first step towards long-standing optimisation ideas
> 
> Basically, it makes struct io_submit_state embedded into ctx, so
> easily accessible and persistent, and then plays a bit around that.

Do you have any perf/latency numbers for this? Just curious if we
see any improvements on that front, cross submit persistence of
alloc caches should be a nice sync win, for example, or even
for peak iops by not having to replenish the pool for each batch.

I can try and run some here too.

-- 
Jens Axboe

