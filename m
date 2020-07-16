Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F85222D7E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 23:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgGPVNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 17:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgGPVNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 17:13:36 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534EBC061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:13:36 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k23so7595815iom.10
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gCQ/CaXL27YxnZQK00+c2qJEARrg/klByIcTew0ifpM=;
        b=S3qvAem+K9WEkCFU26YN6EBFRHBfagG4zIlZu8JrdhCWUEFpsMRzCyd0/K+3k3jjoz
         SzK9w6Hhcs24PQVuXoH5vuAAC+2dVIFYe6IECrauNZDlTWsPKulalagygAGrU+FdRzgf
         P4DHmCYfGxG4M/pJC5i2lyvzIALRLk4dIw/r+tpH0egViJS6vaQvgZF4Or8vEt6dCr4U
         gDZ8fPKHMmFNMGPbI49Lzac3FxXYr7MpeQ3s8zTSDomSeQvYPqclj2oiHNTT7MN7NvLm
         LsfHH0GqY8A+WRoxEu9x9cW1npMNseHNGdCItVPWxhO/QkBrErq0Gczz6fsFOsRoJoGu
         b6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gCQ/CaXL27YxnZQK00+c2qJEARrg/klByIcTew0ifpM=;
        b=OMHMjV4+QFARmJKi/csxlA/OXupw4cYbVpk1yWnGDJtRV+G4RozBPQa6MA0zuICwff
         tn4rb2TwDtB1gNbpYa7GbpQVTr/UcbdmFqEZxJiBFE+49b0BnFW5Kwvgn6gfGK3gmdG5
         Jsn7kqFxaeuMe4aXOP9e/O7LjLEDEPhAtblYxUUNlTfVXp5OVZ8MhVbHrhs56z5Hi8d5
         bdZ/i4YWh23a7/z91bf2tuiC85c5dXZw0Ja5CC8u2X7cKTbuyhLHFXjdzu9+JvMZDLwm
         ZVxGM9fg5JPEtf7Zy2RAgMbSuJdNs/w+KvhvqKgryTXsnugOXUIZqpdyF9CgOAS4V7w7
         zYIw==
X-Gm-Message-State: AOAM530yO+mFbA/OnzYZCRLw37RdzaMqOmPZVL86+dgR0vxLn9daaVKd
        YSDZGewzcaw+2c8apKHYlUN/Yf9YGMmdRQ==
X-Google-Smtp-Source: ABdhPJxcMoii2emTgj7R4EvZDHDABVYBldHnojXOuyeBeR7wZOLbbzfj828vZO9S/Kks83i8KB56SQ==
X-Received: by 2002:a02:8796:: with SMTP id t22mr7402453jai.90.1594934015218;
        Thu, 16 Jul 2020 14:13:35 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w82sm3333436ili.42.2020.07.16.14.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 14:13:34 -0700 (PDT)
Subject: Re: [PATCH 5.9 0/7] recv/rw select-buffer fortifying
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594930020.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9a2d155c-ddc9-8c7a-5f9f-87dcaab02693@kernel.dk>
Date:   Thu, 16 Jul 2020 15:13:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/20 2:27 PM, Pavel Begunkov wrote:
> This series makes selected buffer managment more resilient to errors,
> especially io_recv[msg](). Even though, it makes some small accidential
> optimisations, I don't think performance difference will be observable
> at the end.

I shuffled this a little bit, as it relies on both 5.9 and the leak
fix from 5.8.

Also, some of your commit messages use really short lines, just use
72 consistently for all of them. Minor detail, just not sure why
they are different. I fixed them up.

-- 
Jens Axboe

