Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7326D147489
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 00:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAWXQT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jan 2020 18:16:19 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:37963 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAWXQS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jan 2020 18:16:18 -0500
Received: by mail-pg1-f173.google.com with SMTP id a33so11014pgm.5
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2020 15:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7u70lzSSA6RlHchpbW7YBpwBzJd8X4ojxzHhwIonjlk=;
        b=nVCYWf6f39NnA+oMW62+Ng03l04K5ImwKnvzGnfaRoExKOvvwT8M6eniS+JOQP+ETu
         zgFe+DtKiqyORZ89bfNUph59Yh7UZQiwoQmUuUjYWwdbkuVb5rLPm11G73MRRRVs/UUz
         q1Q3zrWs+/2SZf9MfYjcFp9VkHupnFneZaIbRD9IvUh5IyL7ylF8Fa7KDu+hwpwn+sls
         XvJy+jZO8XVeAYvj7KDeTdDcyCnxeIIsgEinEOOKUR+H68GirgaygFAYnilH5woHuPjN
         mTgjaSu8VsOK1sJRXz4uGj7jd7atEdw3LVlOceREa93X9jH4udG75956dMgt8KByMn31
         2Q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7u70lzSSA6RlHchpbW7YBpwBzJd8X4ojxzHhwIonjlk=;
        b=Tnxwb/dv8XXCZAYG8A1pw1LA/tih0NkzBngPj1FZAV9eQdMoPZgLE3gLHk2QlkJpAp
         qIWbAz6PB+UshjBvzi39BuSQTesTv2H0cxKvk/Em++yDQGoRHvjo/zPoEybLa/t7ICbG
         u+pV8ejDFnSM1B2ep3EjjBCcqCTwUilLVe6KlHAjDo5aSAJvhGJb+jAK31Pvq17oPyHO
         8t/kD2mUH5wkO7AZwQROUzFZYxDSXdTXMhTid3yG5rhVMlZFSkipW9Qc6xxehfOwMZdT
         NwqpXW27CuV5jZ1gae5pn4ojOcultnbyqum+H0gp86zG6nee9UlLSq8754oV5gpmX8fs
         5m2Q==
X-Gm-Message-State: APjAAAXpHofNqoLSVnzdhWZ6qPQv5QBrRosIHfzEuHZKBmNI6jgNXFrD
        MI276/F1Es5hu+I0b+3t8raKB2+Asxk70w==
X-Google-Smtp-Source: APXvYqww+dpCb7vKmFtx5krI5FxnQGGAKye+y4uByBZ4cLt7tgGca6Y07R2Rc8latSbxEewi/jXtsw==
X-Received: by 2002:a63:4006:: with SMTP id n6mr789298pga.139.1579821377863;
        Thu, 23 Jan 2020 15:16:17 -0800 (PST)
Received: from x1.thefacebook.com ([2600:380:4513:6598:c1f4:7b05:f444:ef97])
        by smtp.gmail.com with ESMTPSA id u127sm3766627pfc.95.2020.01.23.15.16.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:16:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Add support for shared io-wq backends
Date:   Thu, 23 Jan 2020 16:16:10 -0700
Message-Id: <20200123231614.10850-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sometimes an applications wants to use multiple smaller rings, because
it's more efficient than sharing a ring. The downside of that is that
we'll create the io-wq backend separately for all of them, while they
would be perfectly happy just sharing that.

This patchset adds support for that. io_uring_params grows an 'id' field,
which denotes an identifier for the async backend. If an application
wants to utilize sharing, it'll simply grab the id from the first ring
created, and pass it in to the next one and set IORING_SETUP_SHARED. This
allows efficient sharing of backend resources, while allowing multiple
rings in the application or library.

Not a huge fan of the IORING_SETUP_SHARED name, we should probably make
that better (I'm taking suggestions).

-- 
Jens Axboe


