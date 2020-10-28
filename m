Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DCB29DA89
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 00:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgJ1XYA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 19:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJ1XK5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 19:10:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1413BC0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 16:10:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o7so770030pgv.6
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 16:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wo0n03tLjMduZLH6lxTOLz88+u7QMB0bvFdgdNHYFFA=;
        b=tPjPUUuijsoghq2QlgW+qFhgWB7StVPZap0gyRryr+EdZRrQir34Smw5nrDy/3G3vI
         0zf9HJfzacnUvZq9pgQyDkQGqlEsOL0Brh+wZxYjrIF7iJdh3pJ+aK8cXZK62L2BL9tS
         teeEVKh3KG6EGtnxVzLkljXao4QyAGGkNyjbhecP5CNVmtDemn/B1itfOMSl0crOGUkt
         3Je7QHLGpgY76OeFtzU5Q2tvxkjzg6Zx7erLnMFpSAjEAC/BI94lIUZWJKma8na8SHiP
         YeSr00qR8lRspXhKk/ZbSQ/xY7V5brPv8LRG20RxXw2E0A2VAwqFUVxjHmRbogtj+cpS
         /h+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wo0n03tLjMduZLH6lxTOLz88+u7QMB0bvFdgdNHYFFA=;
        b=fxddwLdMkqDPeLqnI18qi9bS9LlzyiBW56xphW+GPMtF5HRF4sxzy3lzlETyxbuBCX
         BwsGU/tBxZsTC+wZM3yDYYGPo2nLpSeJ9QE5V2YB84iOrMipbd4BsuhtlyJ9SYHI3GnY
         lW+9PCHfUjNWNbIl9jNY3v5xmc58OQwKzJKgx6uUeXkV/qcAWr0Dt7cxhdWupkUQVMWg
         gyypKIWyMD+zA+9oyz5JjHFb9HXjhqjw1hBqx3fosp5Um80tQ6Ppbzh2kmM1FDJMrKp3
         OVEhOr1PWVnsHb5FtVZ239t6Mbz7LS3kPI5TVPPPcxpZFya7BINuNWD2oxK6+aogmLCT
         cpsg==
X-Gm-Message-State: AOAM531KMZRl0kyuN2Z1qHZpYA9f72chqk+pAYD3IdP83rRfAjyRf014
        YziEd1yN1f6mLbTEDGdlbAXnnZNpsyvsCg==
X-Google-Smtp-Source: ABdhPJzI1N8l5oPYS2bT/KXpW/j4mPXcYhV7vs4BkM0TMk1i/fiHZ0/nHiy5se15VFOp0S/m3B9cgg==
X-Received: by 2002:a92:5b54:: with SMTP id p81mr5967603ilb.290.1603894701671;
        Wed, 28 Oct 2020 07:18:21 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t16sm3147717ild.27.2020.10.28.07.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 07:18:20 -0700 (PDT)
Subject: Re: [PATCH] io_uring: split poll and poll_remove structs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <82ba9ad37b37e28e325f7512ed15c8bda8c19986.1603805098.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <73feead3-4c2b-8034-a6b9-0c8c2c66b2e2@kernel.dk>
Date:   Wed, 28 Oct 2020 08:18:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82ba9ad37b37e28e325f7512ed15c8bda8c19986.1603805098.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/20 5:17 PM, Pavel Begunkov wrote:
> Don't use a single struct for polls and poll remove requests, they have
> totally different layout.

Applied for 5.11 - I renamed it to io_poll_remove instead, fwiw.

-- 
Jens Axboe

